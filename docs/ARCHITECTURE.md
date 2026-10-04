# Arquitectura

El despliegue utiliza Kafka para recibir eventos, ZooKeeper para coordinar Pinot y cuatro roles de Pinot: Controller, Broker, Server y Minion. Docker Compose crea una red común y monta directorios locales para persistir datos.

El flujo funcional es: productor de vuelos → Kafka → Pinot Server → Pinot Broker → consulta SQL.
