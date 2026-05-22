#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ ! -d .venv ]]; then
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r python/requirements.txt
else
    source .venv/bin/activate
fi

echo "==> Creando tablas..."
docker exec -i oracle-vectors sqlplus vec/Vec123@FREEPDB1 < sql/01_schema.sql

echo "==> Importando 200 articulos..."
python3 python/import_news_embeddings.py

echo "==> Importando 8 consultas..."
python3 python/import_query_embeddings.py

echo "==> Listo."
