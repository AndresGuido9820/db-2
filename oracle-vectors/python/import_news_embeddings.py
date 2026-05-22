"""
import_news_embeddings.py
-------------------------
Lee embeddings/news_embeddings.json e inserta las noticias en Oracle.

Usage:
    python python/import_news_embeddings.py
"""

import array
import json
import os

import numpy as np
import oracledb

DB_USER = os.getenv("DB_USER", "vec")
DB_PASSWORD = os.getenv("DB_PASS", "Vec123")
DB_DSN = os.getenv("DB_DSN", "localhost:1522/FREEPDB1")

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
JSON_PATH = os.path.join(BASE_DIR, "embeddings", "news_embeddings.json")


def to_oracle_vector(vec: list) -> array.array:
    return array.array("f", np.array(vec, dtype=np.float32).tolist())


def main():
    print(f"Cargando {JSON_PATH} ...")
    with open(JSON_PATH, encoding="utf-8") as f:
        data = json.load(f)
    print(f"  {len(data)} registros | dims={len(data[0]['embedding'])}")

    print("Conectando a Oracle 23ai ...")
    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    cur = conn.cursor()

    cur.execute("TRUNCATE TABLE news_articles")

    rows = [
        (
            str(rec["texto"]),
            to_oracle_vector(rec["embedding"]),
        )
        for rec in data
    ]

    cur.executemany(
        "INSERT INTO news_articles (content, embedding) VALUES (:1, :2)",
        rows,
    )
    conn.commit()
    cur.close()
    conn.close()

    print(f"Insertados {len(rows)} registros. Listo.")


if __name__ == "__main__":
    main()
