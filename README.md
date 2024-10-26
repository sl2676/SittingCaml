# Sentiment Analysis CLI Tool ~ SittingCaml

This repository contains a sentiment analysis tool that uses OCaml for a command-line interface (CLI) and Python's FastAPI as a backend. The backend is powered by Hugging Face’s Transformers library to analyze the sentiment of input text, providing a simple and powerful way to perform sentiment analysis directly from the command line.

## Features

- **OCaml CLI Interface**: A command-line tool built with OCaml that takes user input and sends it to the backend for sentiment analysis.
- **FastAPI Backend in Python**: A lightweight backend server using FastAPI that hosts a pre-trained model for analyzing sentiment.
- **Machine Learning Integration**: Utilizes Hugging Face Transformers for state-of-the-art NLP capabilities.
- **Flexible and Extensible**: Easy to adapt and extend for different NLP models or additional features.


## Installation

Follow these steps to set up and run the project.
### Set up the Python Environment
```bash
cd python_api
python3 -m venv sentiment_env
source sentiment_env/bin/activate
pip install -r requirements.txt
```

### Run the FastAPI Server with Uvicorn
Start the server to host the sentiment analysis model on http://127.0.0.1:8000
```bash
uvicorn main:app --reload
```

### Build the OCaml CLI
Navigate to the ocaml_cli folder and build the CLI using Dune
```bash
cd ../ocaml_cli
dune build
```

## Usage
Once everything is set up, you can run the CLI tool to analyze sentiment from the command line
```bash
curl -X POST http://127.0.0.1:8000/analyze/ \
     -H "Content-Type: application/json" \
     -d '{"text": "I LOVE LOVE ROBAN"}'
```

Expected output:
```bash
Sentiment: 5 stars (Confidence: 0.79)
```

The FastAPI server will respond with a JSON object containing the sentiment label and confidence score
### Example Output
```bash
curl -X POST http://127.0.0.1:8000/analyze/ \
     -H "Content-Type: application/json" \
     -d '{"text": "I LOVE LOVE ROBAN"}'             

{"label":"5 stars","score":0.7996229529380798}
```
