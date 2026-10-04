# Apache Pinot con Docker

**Estudiante:** Nelson García Copa  
**Proyecto original:** [Apache Pinot](https://github.com/apache/pinot)

Despliegue de Apache Pinot con Docker Compose. La prueba carga datos de vuelos desde Kafka y realiza consultas SQL en tiempo real.

## Ejecutar

```bash
docker compose up -d
./scripts/prueba-funcional.sh
```

Interfaz web: <http://localhost:9000/#/query>

Para detener los contenedores:

```bash
docker compose down
```

Las capturas están en `evidencias/` y el análisis en `docs/`.
