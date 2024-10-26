from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import pipeline
import logging

app = FastAPI()
logging.basicConfig(level=logging.INFO)

try:
    logging.info("Initializing sentiment analysis pipeline...")
    sentiment_pipeline = pipeline("sentiment-analysis", model="nlptown/bert-base-multilingual-uncased-sentiment", device=-1)
    logging.info("Pipeline initialized successfully.")
except Exception as e:
    logging.error(f"Failed to initialize the sentiment pipeline: {e}")
    raise RuntimeError("Model initialization failed")

class TextInput(BaseModel):
    text: str

@app.post("/analyze/")
async def analyze_sentiment(input: TextInput):
    try:
        logging.info(f"Received text: {input.text}")
        result = sentiment_pipeline(input.text)[0]
        logging.info(f"Analysis result: {result}")
        return {
            "label": result["label"],
            "score": result["score"]
        }
    except Exception as e:
        logging.error(f"Error during sentiment analysis: {e}")
        raise HTTPException(status_code=500, detail="Error processing the sentiment analysis")

