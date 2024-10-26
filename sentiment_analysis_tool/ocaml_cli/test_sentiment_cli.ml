(* test_sentiment_cli.ml *)

open OUnit2

(* Assume parse_response is defined in sentiment_cli.ml *)
let parse_response = 
  (* You might need to expose parse_response from sentiment_cli.ml *)
  (* Alternatively, redefine it here for testing purposes *)
  let module SC = struct
    include Sentiment_cli
  end in
  SC.parse_response

let test_parse_response_valid _ =
  let valid_json = "{\"label\": \"POSITIVE\", \"score\": 0.9998}" in
  match parse_response valid_json with
  | Ok ("POSITIVE", 0.9998) -> ()
  | _ -> assert_failure "Failed to parse valid JSON"

let test_parse_response_invalid _ =
  let invalid_json = "{\"label\": \"POSITIVE\"}" in
  match parse_response invalid_json with
  | Error _ -> ()
  | _ -> assert_failure "Failed to handle invalid JSON"

let suite =
  "SentimentCli Tests" >::: [
    "parse_response_valid" >:: test_parse_response_valid;
    "parse_response_invalid" >:: test_parse_response_invalid;
  ]

let () =
  run_test_tt_main suite


