#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PINOT_IMAGE="apachepinot/pinot:1.5.1"
NETWORK="pinot-lg14"
RESULT_DIR="$ROOT_DIR/evidencias/resultados"

cd "$ROOT_DIR"
mkdir -p "$RESULT_DIR"

echo "Esperando al Controller de Pinot..."
for attempt in $(seq 1 60); do
  if curl --fail --silent http://localhost:9000/help >/dev/null; then
    break
  fi
  if [[ "$attempt" -eq 60 ]]; then
    echo "Pinot Controller no respondió a tiempo." >&2
    exit 1
  fi
  sleep 2
done

echo "Comprobando que Kafka esté en ejecución..."
if [[ "$(docker inspect -f '{{.State.Running}}' pinot-kafka 2>/dev/null || true)" != "true" ]]; then
  echo "Kafka no está en ejecución. Revise: docker compose logs kafka" >&2
  exit 1
fi

if curl --fail --silent http://localhost:9000/tables/airlineStats >/dev/null; then
  echo "La tabla airlineStats ya existe."
else
  echo "Creando el esquema y la tabla airlineStats..."
  docker run --rm --network="$NETWORK" "$PINOT_IMAGE" \
    AddTable \
    -schemaFile examples/stream/airlineStats/airlineStats_schema.json \
    -tableConfigFile examples/stream/airlineStats/docker/airlineStats_realtime_table_config.json \
    -controllerHost pinot-controller \
    -controllerPort 9000 \
    -exec

  if ! curl --fail --silent http://localhost:9000/tables/airlineStats >/dev/null; then
    echo "No se pudo crear la tabla airlineStats." >&2
    exit 1
  fi
fi

echo "Publicando el conjunto de vuelos en Kafka..."
docker run --rm --network="$NETWORK" "$PINOT_IMAGE" \
  StreamAvroIntoKafka \
  -avroFile examples/stream/airlineStats/rawdata/airlineStats_data.avro \
  -kafkaTopic flights-realtime \
  -kafkaBrokerList kafka:9092 \
  -millisBetweenMessages 0

echo "Esperando la ingestión de los eventos..."
sleep 12

docker compose ps > "$RESULT_DIR/contenedores.txt"

curl --fail --silent --show-error \
  -X POST http://localhost:8099/query/sql \
  -H 'Content-Type: application/json' \
  -d '{"sql":"SELECT COUNT(*) AS total_registros FROM airlineStats"}' \
  | jq -e 'if (.exceptions // [] | length) == 0 then . else error("La consulta devolvió errores") end' \
  | tee "$RESULT_DIR/consulta-total.json"

curl --fail --silent --show-error \
  -X POST http://localhost:8099/query/sql \
  -H 'Content-Type: application/json' \
  -d '{"sql":"SELECT Carrier, COUNT(*) AS vuelos, AVG(ArrDelayMinutes) AS retraso_promedio FROM airlineStats WHERE ArrDelayMinutes BETWEEN -120 AND 1440 GROUP BY Carrier ORDER BY vuelos DESC LIMIT 10"}' \
  | jq -e 'if (.exceptions // [] | length) == 0 then . else error("La consulta devolvió errores") end' \
  | tee "$RESULT_DIR/consulta-aerolineas.json"

echo
echo "Prueba completada. Resultados guardados en evidencias/resultados/."
