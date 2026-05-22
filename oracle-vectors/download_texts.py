"""
download_texts.py
-----------------
Descarga 200 textos reales del dataset 20 Newsgroups (sklearn),
filtra los que tienen 100-500 palabras y los guarda en:
  - data/texts/   -> un .txt por artículo
  - data/articles.json -> todos juntos con id, topic, title, content
"""

import json
import os
import re

from sklearn.datasets import fetch_20newsgroups

MIN_WORDS = 100
MAX_WORDS = 500
TARGET = 200

CATEGORIES = [
    "sci.space", "sci.med", "sci.electronics", "sci.crypt",
    "rec.sport.hockey", "rec.sport.baseball", "rec.autos", "rec.motorcycles",
    "talk.politics.guns", "talk.politics.misc", "talk.politics.mideast",
    "talk.religion.misc", "soc.religion.christian", "alt.atheism",
    "comp.graphics", "comp.os.ms-windows.misc",
    "comp.sys.ibm.pc.hardware", "comp.sys.mac.hardware",
    "comp.windows.x", "misc.forsale",
]

OUT_DIR = os.path.join(os.path.dirname(__file__), "data", "texts")
JSON_PATH = os.path.join(os.path.dirname(__file__), "data", "articles.json")


def clean(raw: str) -> str:
    lines = raw.splitlines()
    in_header = True
    body = []
    for line in lines:
        if in_header:
            if line.strip() == "":
                in_header = False
            continue
        body.append(line)
    text = " ".join(body)
    return re.sub(r"\s+", " ", text).strip()


def word_count(text: str) -> int:
    return len(text.split())


def main():
    print("Descargando 20newsgroups...")
    data = fetch_20newsgroups(
        subset="all",
        categories=CATEGORIES,
        remove=("headers", "footers", "quotes"),
        shuffle=True,
        random_state=42,
    )

    articles = []
    seen = set()
    for raw, target in zip(data.data, data.target):
        text = clean(raw)
        wc = word_count(text)
        if MIN_WORDS <= wc <= MAX_WORDS:
            key = text[:80]
            if key not in seen:
                seen.add(key)
                articles.append({
                    "id": len(articles) + 1,
                    "title": text[:120].replace("\n", " "),
                    "topic": data.target_names[target].upper().replace(".", "_"),
                    "word_count": wc,
                    "content": text,
                })
        if len(articles) >= TARGET:
            break

    print(f"Encontrados: {len(articles)} textos válidos")

    os.makedirs(OUT_DIR, exist_ok=True)

    # Guardar cada texto como .txt
    for art in articles:
        fname = f"{art['id']:03d}_{art['topic']}.txt"
        fpath = os.path.join(OUT_DIR, fname)
        with open(fpath, "w", encoding="utf-8") as f:
            f.write(f"ID: {art['id']}\n")
            f.write(f"TOPIC: {art['topic']}\n")
            f.write(f"WORDS: {art['word_count']}\n")
            f.write("-" * 60 + "\n")
            f.write(art["content"])

    # Guardar JSON con todos
    with open(JSON_PATH, "w", encoding="utf-8") as f:
        json.dump(articles, f, ensure_ascii=False, indent=2)

    print(f"Textos guardados en: data/texts/  ({len(articles)} archivos .txt)")
    print(f"JSON guardado en:    data/articles.json")
    print(f"\nEjemplo de tópicos:")
    topics = {}
    for a in articles:
        topics[a["topic"]] = topics.get(a["topic"], 0) + 1
    for t, c in sorted(topics.items(), key=lambda x: -x[1]):
        print(f"  {c:3d}  {t}")


if __name__ == "__main__":
    main()
