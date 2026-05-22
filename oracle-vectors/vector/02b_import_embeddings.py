"""
02b_import_embeddings.py
------------------------
Lee 200_noticias_con_embeddings.json e inserta directo en Oracle 23ai.

Usage:
    python 02b_import_embeddings.py
"""

import array
import json
import os

import numpy as np
import oracledb

DB_USER = "vec"
DB_PASSWORD = "Vec123"
DB_DSN = "localhost:1522/FREEPDB1"

JSON_PATH = os.path.join(os.path.dirname(__file__), "200_noticias_con_embeddings.json")


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
            str(rec["texto"])[:200].replace("\n", " "),
            str(rec["texto"]),
            to_oracle_vector(rec["embedding"]),
        )
        for rec in data
    ]

    cur.executemany(
        "INSERT INTO news_articles (title, content, embedding) VALUES (:1, :2, :3)",
        rows,
    )
    conn.commit()
    cur.close()
    conn.close()

    print(f"Insertados {len(rows)} registros. Listo.")


if __name__ == "__main__":
    main()
