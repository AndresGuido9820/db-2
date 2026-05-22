#!/usr/bin/env bash
# run.sh — Ejecuta un archivo SQL contra Oracle (como usuario dev)
# Uso: ./run.sh sql/ejemplo_basico.sql
#      ./run.sh sql/insertar_datos.sql 10000
#      DB_USER=system DB_PASS=Oracle123 ./run.sh sql/mi_script.sql

set -euo pipefail

SQL_FILE="${1:-}"
DB_USER="${DB_USER:-dev}"
DB_PASS="${DB_PASS:-Dev123}"
CONTAINER="oracle-plsql"

if [[ -z "$SQL_FILE" ]]; then
    echo "Uso: ./run.sh <archivo.sql> [argumentos_sqlplus...]"
    echo "Ejemplo: ./run.sh sql/insertar_datos.sql 10000"
    exit 1
fi

if [[ ! -f "$SQL_FILE" ]]; then
    echo "Error: archivo '$SQL_FILE' no encontrado."
    exit 1
fi

FILENAME=$(basename "$SQL_FILE")
shift || true
SQL_ARGS="$*"

echo "[run] Ejecutando $SQL_FILE como $DB_USER..."

docker cp "$SQL_FILE" "$CONTAINER":/tmp/"$FILENAME"
docker exec -i "$CONTAINER" sqlplus -s "$DB_USER/$DB_PASS@//localhost/XE" @/tmp/"$FILENAME" $SQL_ARGS
