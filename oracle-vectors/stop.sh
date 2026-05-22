#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Stopping Oracle Vector..."
docker compose down
echo "Oracle Vector stopped. Data persists in the oracle_vectors_data volume."
echo "To remove persisted data too, run: docker compose down -v"
