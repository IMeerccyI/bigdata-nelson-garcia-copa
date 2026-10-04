# Comparación con Big Data Europe Docker Hadoop

| Característica | Docker Hadoop | Apache Pinot |
|---|---|---|
| Tecnología principal | Hadoop 3.2.1, HDFS y YARN | Pinot 1.5.1 y Kafka 4.0.0 |
| Docker | Sí | Sí |
| Docker Compose | Sí | Sí |
| Número de contenedores | 5 | 6 |
| Almacenamiento distribuido | Bloques de archivos en HDFS | Segmentos columnares administrados por Pinot Server |
| Procesamiento distribuido | MapReduce coordinado por YARN | Consultas OLAP distribuidas e ingestión continua |
| Interfaces web | NameNode, DataNode, ResourceManager y HistoryServer | Controller y explorador de consultas SQL |
| Persistencia | Volúmenes para NameNode, DataNode e historial | Directorios montados para Kafka, ZooKeeper, Controller, Server y Minion |
| Complejidad de instalación | Media | Media |
| Documentación | README y configuración de Hadoop | Documentación oficial, README y API web |
| Caso de uso | Almacenamiento masivo y procesamiento por lotes | Analítica de eventos en tiempo real y consultas de baja latencia |

Hadoop prioriza el almacenamiento distribuido y el procesamiento por lotes. Pinot prioriza la ingestión continua y las consultas analíticas rápidas sobre eventos recientes. Ninguno es mejor en todos los casos: responden a necesidades diferentes.
