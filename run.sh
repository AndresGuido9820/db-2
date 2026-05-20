#!/usr/bin/env bash
# run.sh — Ejecuta un archivo SQL contra Oracle (como usuario dev)
# Uso: ./run.sh scripts/ejemplo_basico.sql
#      ./run.sh scripts/procedimiento.sql
#      ./run.sh scripts/mi_script.sql system Oracle123   (usuario/pass opcional)

set -euo pipefail

SQL_FILE="${1:-}"
DB_USER="${2:-dev}"
DB_PASS="${3:-Dev123}"
CONTAINER="oracle-plsql"

if [[ -z "$SQL_FILE" ]]; then
    echo "Uso: ./run.sh <archivo.sql> [usuario] [password]"
    echo "Ejemplo: ./run.sh scripts/ejemplo_basico.sql"
    exit 1
fi

if [[ ! -f "$SQL_FILE" ]]; then
    echo "Error: archivo '$SQL_FILE' no encontrado."
    exit 1
fi

FILENAME=$(basename "$SQL_FILE")

echo "[run] Ejecutando $SQL_FILE como $DB_USER..."

docker cp "$SQL_FILE" "$CONTAINER":/tmp/"$FILENAME"
docker exec -i "$CONTAINER" sqlplus -s "$DB_USER/$DB_PASS@//localhost/XE" @/tmp/"$FILENAME"
