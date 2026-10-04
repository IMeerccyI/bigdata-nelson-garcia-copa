# Apache Pinot con Docker

**Estudiante:** Nelson Daniel García Copa
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

El informe está en `informe/`, el diagrama editable en `diagrama/arquitectura-pinot.drawio` y las capturas en `evidencias/`.
