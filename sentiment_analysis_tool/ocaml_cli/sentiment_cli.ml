
open Lwt.Infix
open Cohttp
open Cohttp_lwt_unix
open Cmdliner

type text_input = {
  text : string;
}

let text_input_to_yojson ti =
  `Assoc [("text", `String ti.text)]
  |> Yojson.Safe.to_string

let analyze_sentiment text =
  let uri = Uri.of_string "http://127.0.0.1:8000/analyze/" in
  let headers = Header.init_with "Content-Type" "application/json" in
  let body = `String (text_input_to_yojson { text }) in
  Client.post ~headers ~body uri >>= fun (resp, _) -> 
  let status = Response.status resp in
  if Code.(is_success (code_of_status status)) then
    body |> Cohttp_lwt.Body.to_string >|= fun body_str ->
    Ok body_str
  else
    body |> Cohttp_lwt.Body.to_string >|= fun body_str ->
    Error (Printf.sprintf "Error: %s" body_str)

let parse_response json_str =
  try
    let json = Yojson.Safe.from_string json_str in
    let label = Yojson.Safe.Util.(json |> member "label" |> to_string) in
    let score = Yojson.Safe.Util.(json |> member "score" |> to_float) in
    Ok (label, score)
  with
  | Yojson.Json_error msg
  | Yojson.Safe.Util.Type_error (msg, _) -> Error msg

let main text =
  Lwt_main.run (
    analyze_sentiment text >>= function
    | Ok response ->
        (match parse_response response with
         | Ok (label, score) ->
             Printf.printf "Sentiment: %s (Confidence: %.4f)\n" label score;
             Lwt.return_unit
         | Error msg ->
             Printf.eprintf "Failed to parse response: %s\n" msg;
             Lwt.return_unit)
    | Error msg ->
        Printf.eprintf "Request failed: %s\n" msg;
        Lwt.return_unit
  )

let text_arg =
  let doc = "Text to analyze sentiment for." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"TEXT" ~doc)

let info =
  Cmd.info "sentiment_cli"
    ~version:"1.0"
    ~doc:"A simple sentiment analysis CLI tool using OCaml and a Python backend."
    ~exits:Cmd.Exit.defaults

let cmd =
  Cmd.v info (Term.(const main $ text_arg))

let () =
  exit (Cmd.eval cmd)

