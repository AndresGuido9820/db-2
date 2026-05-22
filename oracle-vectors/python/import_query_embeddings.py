"""
import_query_embeddings.py
--------------------------
Lee embeddings/query_embeddings.json e inserta las consultas en Oracle.
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
JSON_PATH = os.path.join(BASE_DIR, "embeddings", "query_embeddings.json")

LABELS = {
    1: "Query_Economia",
    2: "Query_Emocion",
    3: "Query_Animales",
    4: "Query_Vaga",
    5: "Query_Evento",
    6: "Query_Tecnologia",
    7: "Query_Politica",
    8: "Query_Frutas",
}


def to_oracle_vector(vec: list) -> array.array:
    return array.array("f", np.array(vec, dtype=np.float32).tolist())


def main():
    print(f"Cargando {JSON_PATH} ...")
    with open(JSON_PATH, encoding="utf-8") as f:
        data = json.load(f)
    print(f"  {len(data)} consultas | dims={len(data[0]['embedding'])}")

    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    cur = conn.cursor()

    cur.execute("DELETE FROM query_vectors")

    rows = [
        (
            int(rec["id_consulta"]),
            LABELS.get(int(rec["id_consulta"]), ""),
            str(rec["texto_consulta"]),
            to_oracle_vector(rec["embedding"]),
        )
        for rec in data
    ]

    cur.executemany(
        "INSERT INTO query_vectors (id, label, query_text, embedding) VALUES (:1, :2, :3, :4)",
        rows,
    )
    conn.commit()
    cur.close()
    conn.close()

    print("Insertadas 8 consultas en query_vectors. Listo.")


if __name__ == "__main__":
    main()
