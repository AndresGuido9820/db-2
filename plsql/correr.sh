#!/usr/bin/env bash
# correr.sh — Corre sql/mi_script.sql contra Oracle

CONTAINER="oracle-plsql"
DB_USER="dev"
DB_PASS="Dev123"
SQL_FILE="sql/mi_script.sql"

docker cp "$SQL_FILE" "$CONTAINER":/tmp/mi_script.sql 2>/dev/null
docker exec -i "$CONTAINER" sqlplus -s "$DB_USER/$DB_PASS@//localhost/XE" <<'EOF'
SET SERVEROUTPUT ON SIZE UNLIMITED
@/tmp/mi_script.sql
EXIT;
EOF
