#!/usr/bin/env bash
# start.sh — Levanta el contenedor Oracle y espera a que este listo

set -euo pipefail

echo "[start] Iniciando Oracle XE 21c..."
docker compose up -d

echo "[start] Esperando a que Oracle este listo (puede tomar 2-3 minutos la primera vez)..."

until docker compose exec -T oracle healthcheck.sh 2>/dev/null; do
    echo "  ... Oracle aun iniciando, esperando 10s"
    sleep 10
done

echo "[start] Oracle listo."
echo ""
echo "  Host    : localhost:1521"
echo "  SID     : XE"
echo "  SYS     : system / Oracle123"
echo "  App user: dev    / Dev123"
echo ""
echo "Usa './run.sh sql/ejemplo_basico.sql' para ejecutar un script."
