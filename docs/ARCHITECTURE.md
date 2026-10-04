# Arquitectura

El despliegue utiliza Kafka para recibir eventos, ZooKeeper para coordinar Pinot y cuatro roles de Pinot: Controller, Broker, Server y Minion. Docker Compose crea la red `pinot-lg14`, un volumen para Kafka y directorios locales para los datos de ZooKeeper y Pinot.

El flujo funcional es: productor de vuelos → Kafka → Pinot Server → Pinot Broker → consulta SQL.

Puertos publicados: ZooKeeper 2181, Kafka 9092, Controller 9000, Server 8098, Broker 8099 y Minion 9514.
