SELECT COUNT(*) FROM transactions; 


--Tasa de fraude general
SELECT 
    class,
    COUNT(*) AS total_transacciones,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM transactions
GROUP BY class;

--Monto promedio, mínimo y máximo por clase
SELECT 
    class,
    COUNT(*) AS total,
    ROUND(AVG(amount)::numeric, 2) AS monto_promedio,
    MIN(amount) AS monto_minimo,
    MAX(amount) AS monto_maximo,
    ROUND(SUM(amount)::numeric, 2) AS monto_total
FROM transactions
GROUP BY class;

--Fraude por hora del día

SELECT 
    FLOOR(time_seconds / 3600)::int % 24 AS hora,
    COUNT(*) AS total_transacciones,
    SUM(CASE WHEN class = 1 THEN 1 ELSE 0 END) AS fraudes,
    ROUND(100.0 * SUM(CASE WHEN class = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS tasa_fraude_pct
FROM transactions
GROUP BY hora
ORDER BY hora;


--Horas con mayor riesgo (ordenado por tasa, no por conteo)
SELECT 
    FLOOR(time_seconds / 3600)::int % 24 AS hora,
    COUNT(*) AS total_transacciones,
    SUM(CASE WHEN class = 1 THEN 1 ELSE 0 END) AS fraudes,
    ROUND(100.0 * SUM(CASE WHEN class = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS tasa_fraude_pct
FROM transactions
GROUP BY hora
ORDER BY tasa_fraude_pct DESC
LIMIT 5;

--Percentiles de monto (detección de outliers con SQL puro) 
SELECT
    class,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) AS p25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY amount) AS mediana,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) AS p75,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY amount) AS p95,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY amount) AS p99
FROM transactions
GROUP BY class;

--Ranking de las transacciones fraudulentas más grandes (usando funciones de ventana)
SELECT 
    time_seconds,
    amount,
    RANK() OVER (ORDER BY amount DESC) AS ranking
FROM transactions
WHERE class = 1
ORDER BY amount DESC
LIMIT 10;

--Comparación acumulada — qué % del monto total de fraude representa el top 10% de transacciones fraudulentas 
--más grandes (concentración del riesgo)
WITH fraudes_ordenados AS (
    SELECT 
        amount,
        NTILE(10) OVER (ORDER BY amount DESC) AS decil
    FROM transactions
    WHERE class = 1
)
SELECT 
    decil,
    COUNT(*) AS transacciones,
    ROUND(SUM(amount)::numeric, 2) AS monto_decil,
    ROUND(100.0 * SUM(amount) / SUM(SUM(amount)) OVER (), 2) AS pct_del_total
FROM fraudes_ordenados
GROUP BY decil
ORDER BY decil;

