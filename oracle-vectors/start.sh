#!/usr/bin/env bash
set -e
echo "Starting Oracle 23ai Free (port 1522)..."
docker compose up -d
echo "Waiting for Oracle to be healthy..."
until docker inspect --format='{{.State.Health.Status}}' oracle-vectors 2>/dev/null | grep -q "healthy"; do
  sleep 5
  echo "  still waiting..."
done
echo "Oracle is ready."
