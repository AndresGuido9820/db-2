"""
02_embed_insert.py
------------------
1. Downloads 20 Newsgroups dataset (real English news/posts via sklearn).
2. Filters to 200 texts with 100-500 words.
3. Generates 384-dim embeddings with all-MiniLM-L6-v2.
4. Inserts everything into Oracle 23ai (news_articles table).

Usage:
    python 02_embed_insert.py
"""

import array
import re
import sys

import numpy as np
import oracledb
from sentence_transformers import SentenceTransformer
from sklearn.datasets import fetch_20newsgroups

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
DB_USER = "vec"
DB_PASSWORD = "Vec123"
DB_DSN = "localhost:1522/FREEPDB1"

MODEL_NAME = "all-MiniLM-L6-v2"   # 384 dims, fast, good quality
TARGET_COUNT = 200
MIN_WORDS = 100
MAX_WORDS = 500

# Categories we want (keeps the corpus thematically varied)
CATEGORIES = [
    "sci.space",
    "sci.med",
    "rec.sport.hockey",
    "rec.sport.baseball",
    "rec.autos",
    "talk.politics.guns",
    "talk.politics.misc",
    "comp.graphics",
    "comp.os.ms-windows.misc",
    "sci.electronics",
    "talk.religion.misc",
    "soc.religion.christian",
    "rec.motorcycles",
    "sci.crypt",
    "misc.forsale",
    "talk.politics.mideast",
    "comp.sys.ibm.pc.hardware",
    "comp.sys.mac.hardware",
    "comp.windows.x",
    "alt.atheism",
]


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def clean_text(raw: str) -> str:
    """Remove email headers and blank lines from newsgroup posts."""
    lines = raw.splitlines()
    # Skip header block (lines before first blank line)
    in_header = True
    body_lines = []
    for line in lines:
        if in_header:
            if line.strip() == "":
                in_header = False
            continue
        body_lines.append(line)
    text = " ".join(body_lines)
    # Collapse whitespace
    text = re.sub(r"\s+", " ", text).strip()
    return text


def word_count(text: str) -> int:
    return len(text.split())


def to_oracle_vector(vec: np.ndarray) -> array.array:
    """Convert numpy float32 array to Python array for oracledb VECTOR binding."""
    return array.array("f", vec.astype(np.float32).tolist())


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    # 1. Load dataset
    print("Fetching 20newsgroups dataset …")
    data = fetch_20newsgroups(
        subset="all",
        categories=CATEGORIES,
        remove=("headers", "footers", "quotes"),
        shuffle=True,
        random_state=42,
    )

    # 2. Filter by word count and deduplicate roughly
    articles = []
    seen = set()
    for raw, target in zip(data.data, data.target):
        text = clean_text(raw)
        wc = word_count(text)
        if MIN_WORDS <= wc <= MAX_WORDS:
            key = text[:80]
            if key not in seen:
                seen.add(key)
                articles.append({
                    "title": text[:100].replace("\n", " "),
                    "topic": data.target_names[target].upper().replace(".", "_"),
                    "content": text,
                })
        if len(articles) >= TARGET_COUNT:
            break

    if len(articles) < TARGET_COUNT:
        print(f"WARNING: only found {len(articles)} qualifying articles "
              f"(need {TARGET_COUNT}). Relax MIN/MAX_WORDS or add categories.")
        sys.exit(1)

    print(f"Selected {len(articles)} articles.")

    # 3. Generate embeddings
    print(f"Loading model '{MODEL_NAME}' …")
    model = SentenceTransformer(MODEL_NAME)

    contents = [a["content"] for a in articles]
    print("Encoding texts …")
    embeddings = model.encode(contents, batch_size=32, show_progress_bar=True,
                              normalize_embeddings=True)
    print(f"Embeddings shape: {embeddings.shape}")

    # 4. Insert into Oracle
    print("Connecting to Oracle 23ai …")
    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    cur = conn.cursor()

    cur.execute("TRUNCATE TABLE news_articles")

    sql = """
        INSERT INTO news_articles (title, topic, content, embedding)
        VALUES (:1, :2, :3, :4)
    """

    rows = []
    for art, emb in zip(articles, embeddings):
        rows.append((
            art["title"][:400],
            art["topic"][:100],
            art["content"],
            to_oracle_vector(emb),
        ))

    cur.executemany(sql, rows)
    conn.commit()
    cur.close()
    conn.close()

    print(f"Inserted {len(rows)} rows into news_articles. Done.")


if __name__ == "__main__":
    main()
