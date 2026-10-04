# Análisis del repositorio Apache Pinot

Datos consultados el 4 de octubre de 2026 en el [repositorio oficial](https://github.com/apache/pinot) y su [documentación](https://docs.pinot.apache.org/).

## Información general

| Dato | Resultado |
|---|---|
| Nombre | Apache Pinot |
| Autor u organización | Apache Software Foundation |
| Repositorio | <https://github.com/apache/pinot> |
| Objetivo | Base de datos OLAP distribuida para analizar grandes volúmenes de eventos con baja latencia |
| Creación en GitHub | 19 de mayo de 2014 |
| Última actualización observada | 4 de octubre de 2026 |
| Estrellas / forks observados | 6.148 / 1.520 |
| Lenguaje principal | Java |
| Licencia | Apache License 2.0 |
| Commit inspeccionado | `7a00b2318bee93bb6de8bc8538685fab76cc3c95` |

El proyecto permite ingerir datos por lotes o en streaming y consultarlos con SQL. Es apropiado para tableros, métricas operativas, telemetría, actividad de usuarios y otros casos donde los resultados deben aparecer en segundos.

## Tecnologías del despliegue

- Apache Pinot 1.5.1 con Java 21 sobre Ubuntu 24.04.
- Apache Kafka 4.0.0 como entrada de eventos.
- Apache ZooKeeper 3.9.3 para coordinación del clúster.
- Docker y Docker Compose para crear la infraestructura.
- Bash, `curl` y `jq` para automatizar y validar la prueba.

## Arquitectura analizada

Docker Compose crea una red llamada `pinot-lg14` y seis contenedores:

| Servicio | Función | Puerto publicado | Dependencias principales |
|---|---|---:|---|
| ZooKeeper | Coordinación y metadatos del clúster | 2181 | Ninguna |
| Kafka | Cola de eventos de vuelos | 9092 | Ninguna |
| Pinot Controller | Administra tablas, esquemas y nodos | 9000 | ZooKeeper y Kafka |
| Pinot Server | Guarda segmentos y ejecuta consultas | 8098 | Controller, ZooKeeper y Kafka |
| Pinot Broker | Recibe SQL y distribuye consultas | 8099 | Controller, ZooKeeper y Kafka |
| Pinot Minion | Ejecuta tareas de mantenimiento | 9514 | Controller, ZooKeeper y Kafka |

Kafka utiliza un volumen administrado por Docker. ZooKeeper, Controller y Server conservan sus datos en `pinot-docker-demo/`, carpeta ignorada por Git porque se genera durante la ejecución. Las versiones de las imágenes están fijadas para que el despliegue sea reproducible.

El recorrido de los datos es:

1. El script publica el archivo Avro de vuelos en el tema `flights-realtime` de Kafka.
2. Pinot Server consume los eventos y construye el segmento de la tabla `airlineStats`.
3. El usuario envía SQL al Pinot Broker.
4. El Broker consulta al Server y devuelve el resultado.

El diagrama se encuentra en [`diagrama/arquitectura-pinot.svg`](../diagrama/arquitectura-pinot.svg).

## Prueba funcional realizada

Se levantaron los seis servicios y se cargó el conjunto de vuelos incluido en la imagen oficial de Pinot. La ejecución comprobada produjo:

- seis contenedores en estado `Up`;
- tabla `airlineStats` creada correctamente;
- 9.864 eventos disponibles durante la ejecución documentada;
- consulta agrupada por aerolínea sin excepciones;
- 1 Server consultado y 1 Server respondido.

El resultado mostró, por ejemplo, 1.489 vuelos válidos para `WN` con un retraso promedio de 20,40 minutos. La consulta excluye valores ausentes mediante un rango válido de retraso. Los JSON completos y las capturas están en [`evidencias/`](../evidencias/).

## Conclusión

Apache Pinot cumplió el flujo solicitado: encontrar, comprender, desplegar, probar y analizar. Frente a Hadoop, su principal ventaja en este escenario es consultar eventos recientes con baja latencia; Hadoop resulta más natural para almacenamiento distribuido de archivos y trabajos por lotes. La comparación completa está en [`COMPARACION-HADOOP.md`](COMPARACION-HADOOP.md).
