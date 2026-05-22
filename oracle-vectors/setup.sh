#!/usr/bin/env bash
# Full pipeline: start Oracle, create table, install deps, embed & insert.
set -e
cd "$(dirname "$0")"

echo "=== 1. Start Oracle 23ai ==="
./start.sh

echo "=== 2. Create table ==="
docker exec -i oracle-vectors sqlplus vec/Vec123@FREEPDB1 < vector/01_ddl.sql

echo "=== 3. Install Python deps ==="
pip install -r vector/requirements.txt

echo "=== 4. Embed & insert 200 articles ==="
python vector/02_embed_insert.py

echo "=== Done. Run queries with: python vector/03_queries.py ==="
