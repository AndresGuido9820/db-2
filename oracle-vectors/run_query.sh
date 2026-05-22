#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="${1:-sql/02_vector_queries.sql}"

if [[ "$SQL_FILE" != /* ]]; then
    if [[ -f "$SQL_FILE" ]]; then
        SQL_FILE="$(pwd)/$SQL_FILE"
    else
        SQL_FILE="$SCRIPT_DIR/$SQL_FILE"
    fi
fi

if [[ ! -f "$SQL_FILE" ]]; then
    echo "ERROR: no existe '$SQL_FILE'"
    exit 1
fi

docker cp "$SQL_FILE" oracle-vectors:/tmp/query.sql
docker exec oracle-vectors sqlplus -S "${DB_USER:-vec}/${DB_PASS:-Vec123}@FREEPDB1" @/tmp/query.sql
