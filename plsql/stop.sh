#!/usr/bin/env bash
# stop.sh — Detiene el contenedor Oracle (los datos persisten en el volumen)

set -euo pipefail

echo "[stop] Deteniendo Oracle..."
docker compose down
echo "[stop] Contenedor detenido. Los datos persisten en el volumen 'oracle_data'."
echo "       Para borrar todo incluidos los datos: docker compose down -v"
