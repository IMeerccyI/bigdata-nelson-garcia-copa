-- Cantidad total de eventos ingeridos.
SELECT COUNT(*) AS total_registros
FROM airlineStats;

-- Aerolíneas con más vuelos y su retraso promedio de llegada.
SELECT
    Carrier,
    COUNT(*) AS vuelos,
    AVG(ArrDelayMinutes) AS retraso_promedio
FROM airlineStats
GROUP BY Carrier
ORDER BY vuelos DESC
LIMIT 10;
