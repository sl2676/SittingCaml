from transformers import pipeline

try:
    sentiment_pipeline = pipeline("sentiment-analysis", model="nlptown/bert-base-multilingual-uncased-sentiment", device=-1)
    result = sentiment_pipeline("I love using OCaml for functional programming!")[0]
    print("Model Output:", result)
except Exception as e:
    print("Error:", e)

