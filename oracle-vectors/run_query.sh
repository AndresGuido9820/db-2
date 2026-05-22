#!/usr/bin/env bash
set -euo pipefail

SQL_FILE="${1:-vector/queries.sql}"

if [[ ! -f "$SQL_FILE" ]]; then
    echo "ERROR: no existe '$SQL_FILE'"
    exit 1
fi

docker cp "$SQL_FILE" oracle-vectors:/tmp/query.sql
docker exec oracle-vectors sqlplus -S vec/Vec123@FREEPDB1 @/tmp/query.sql
