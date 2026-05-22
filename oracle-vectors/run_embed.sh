#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ ! -d .venv ]]; then
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r vector/requirements.txt
else
    source .venv/bin/activate
fi

echo "==> Creando tablas..."
docker exec -i oracle-vectors sqlplus vec/Vec123@FREEPDB1 < vector/01_ddl.sql

echo "==> Importando 200 articulos..."
python3 vector/02b_import_embeddings.py

echo "==> Importando 8 consultas..."
python3 vector/embed_queries.py

echo "==> Listo."
