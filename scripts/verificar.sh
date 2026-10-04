#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Servicios del Compose:"
docker compose config --services

echo
echo "Estado de los contenedores:"
docker compose ps

echo
echo "Tabla airlineStats:"
curl --fail --silent http://localhost:9000/tables/airlineStats | jq .
