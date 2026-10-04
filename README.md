# Apache Pinot con Docker

Proyecto académico de Big Data basado en el repositorio público [apache/pinot](https://github.com/apache/pinot).

**Estudiante:** Nelson García Copa  
**Universidad:** Universidad del Valle  
**Tecnología principal:** Apache Pinot  
**Licencia del proyecto original:** Apache License 2.0

## Objetivo

Desplegar un clúster local de Apache Pinot con Docker Compose, cargar eventos de vuelos mediante Apache Kafka y realizar consultas analíticas en tiempo real.

## Componentes

- ZooKeeper: coordinación del clúster Pinot.
- Kafka: recepción de eventos en tiempo real.
- Pinot Controller: administración del clúster.
- Pinot Server: almacenamiento y procesamiento de segmentos.
- Pinot Broker: recepción y distribución de consultas.
- Pinot Minion: tareas de mantenimiento.

## Ejecución

```bash
docker compose up -d
docker compose ps
./scripts/prueba-funcional.sh
```

La interfaz de consultas se encuentra en <http://localhost:9000/#/query>.

Para detener el entorno:

```bash
docker compose down
```

## Contenido

- `docker-compose.yml`: despliegue de los seis servicios.
- `scripts/`: automatización de la prueba funcional.
- `diagrama/`: arquitectura real del despliegue.
- `evidencias/`: capturas y resultados obtenidos.
- `docs/COMPARACION-HADOOP.md`: comparación con Big Data Europe Docker Hadoop.
