"""
03_queries.py
-------------
Executes 8 natural-language queries against the Oracle 23ai vector store.
For each query:
  - Embeds the query text with the same model used at insert time.
  - Retrieves top-10 results using VECTOR_DISTANCE (cosine).
  - Repeats with TARGET ACCURACY 90, 70, 50 percent (approximate search).
  - Prints results and a brief relevance judgement.

Usage:
    python 03_queries.py
"""

import array
import textwrap

import numpy as np
import oracledb
from sentence_transformers import SentenceTransformer

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
DB_USER = "vec"
DB_PASSWORD = "Vec123"
DB_DSN = "localhost:1522/FREEPDB1"
MODEL_NAME = "all-MiniLM-L6-v2"
TOP_K = 10

# ---------------------------------------------------------------------------
# Eight queries: varied in nature as required by the assignment
# ---------------------------------------------------------------------------
QUERIES = [
    {
        "id": 1,
        "label": "Exact-phrase (space science)",
        "text": "NASA space shuttle orbit launch mission",
        "note": "Exact terms likely present in sci.space posts.",
    },
    {
        "id": 2,
        "label": "Topical (medicine & disease)",
        "text": "disease symptoms treatment medical doctor hospital",
        "note": "Topic-level match against sci.med articles.",
    },
    {
        "id": 3,
        "label": "Abstract emotion (anger & conflict)",
        "text": "anger hatred violence war conflict",
        "note": "Emotional/abstract concept – may surface politics or religion.",
    },
    {
        "id": 4,
        "label": "General category (sports)",
        "text": "game team score win championship",
        "note": "General sports vocabulary expected in rec.sport.*",
    },
    {
        "id": 5,
        "label": "Specific technical (encryption & security)",
        "text": "encryption key algorithm cryptography security",
        "note": "Should match sci.crypt posts closely.",
    },
    {
        "id": 6,
        "label": "Abstract concept (God & faith)",
        "text": "God faith belief religion prayer soul",
        "note": "Expected in talk.religion.misc and soc.religion.christian.",
    },
    {
        "id": 7,
        "label": "Buying & selling items",
        "text": "for sale price buy sell offer shipping",
        "note": "Should match misc.forsale listings.",
    },
    {
        "id": 8,
        "label": "Very vague / imprecise",
        "text": "interesting stuff happened somewhere recently",
        "note": "Deliberately vague – results should be unpredictable.",
    },
]


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def to_oracle_vector(vec: np.ndarray) -> array.array:
    return array.array("f", vec.astype(np.float32).tolist())


def run_exact(cur, vec, top_k: int):
    sql = f"""
        SELECT id, topic, SUBSTR(content, 1, 120) AS snippet,
               VECTOR_DISTANCE(embedding, :1, COSINE) AS dist
        FROM news_articles
        ORDER BY dist
        FETCH FIRST {top_k} ROWS ONLY
    """
    cur.execute(sql, [vec])
    return cur.fetchall()


def run_approximate(cur, vec, accuracy: int, top_k: int):
    sql = f"""
        SELECT id, topic, SUBSTR(content, 1, 120) AS snippet,
               VECTOR_DISTANCE(embedding, :1, COSINE) AS dist
        FROM news_articles
        ORDER BY VECTOR_DISTANCE(embedding, :1, COSINE)
        FETCH APPROXIMATE FIRST {top_k} ROWS ONLY
        WITH TARGET ACCURACY {accuracy} PERCENT
    """
    cur.execute(sql, [vec, vec])
    return cur.fetchall()


def print_results(rows, label=""):
    if label:
        print(f"  [{label}]")
    for rank, (rid, topic, snippet, dist) in enumerate(rows, 1):
        snip = textwrap.shorten(snippet or "", width=90, placeholder="…")
        print(f"    {rank:2d}. [dist={dist:.4f}] topic={topic:<30s} | {snip}")


def result_ids(rows):
    return [r[0] for r in rows]


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    print(f"Loading model '{MODEL_NAME}' …")
    model = SentenceTransformer(MODEL_NAME)

    print("Connecting to Oracle 23ai …\n")
    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    cur = conn.cursor()

    accuracy_levels = [100, 90, 70, 50]   # 100 = exact (no approximation)

    for q in QUERIES:
        print("=" * 80)
        print(f"QUERY {q['id']}: {q['label']}")
        print(f"  Text  : \"{q['text']}\"")
        print(f"  Note  : {q['note']}")
        print()

        vec = model.encode([q["text"]], normalize_embeddings=True)[0]
        oracle_vec = to_oracle_vector(vec)

        exact_ids = None
        results_by_acc = {}

        for acc in accuracy_levels:
            if acc == 100:
                rows = run_exact(cur, oracle_vec, TOP_K)
                lbl = "EXACT (no approximation)"
                exact_ids = result_ids(rows)
            else:
                rows = run_approximate(cur, oracle_vec, acc, TOP_K)
                lbl = f"TARGET ACCURACY {acc}%"

            results_by_acc[acc] = result_ids(rows)
            print_results(rows, lbl)
            print()

        # Diff vs exact
        print("  --- Comparison vs EXACT ---")
        for acc in [90, 70, 50]:
            changed = set(exact_ids) - set(results_by_acc[acc])
            added   = set(results_by_acc[acc]) - set(exact_ids)
            print(f"    ACC {acc}%: "
                  f"lost={sorted(changed)}, gained={sorted(added)}")
        print()

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
