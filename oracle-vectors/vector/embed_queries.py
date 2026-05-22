"""
embed_queries.py
----------------
Lee 8_consultas_con_embeddings.json e inserta los vectores
en la tabla query_vectors de Oracle 23ai.
"""

import array
import json
import os

import numpy as np
import oracledb

DB_USER = "vec"
DB_PASSWORD = "Vec123"
DB_DSN = "localhost:1522/FREEPDB1"

JSON_PATH = os.path.join(os.path.dirname(__file__), "8_consultas_con_embeddings.json")

LABELS = {
    1: "Frase exacta - economia",
    2: "Emocion abstracta - tristeza",
    3: "Concepto general - animales",
    4: "Consulta vaga",
    5: "Pregunta directa - cine",
    6: "Concepto tecnico - innovacion",
    7: "Ensalada de palabras - politica",
    8: "Fuera de contexto - frutas",
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
