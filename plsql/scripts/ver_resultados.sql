SET PAGESIZE 200
SET LINESIZE 150
SET VERIFY OFF

COLUMN metodo_usado     FORMAT A20
COLUMN tiempo_ms        FORMAT 999,999,999
COLUMN numero_facturas  FORMAT 999,999,999
COLUMN numero_detalles  FORMAT 999,999,999
COLUMN limite_bulk      FORMAT 999,999,999

SELECT
    numero_facturas,
    numero_detalles,
    metodo_usado,
    limite_bulk,
    tiempo_ejecucion AS tiempo_ms
FROM resultados
ORDER BY numero_facturas, metodo_usado, limite_bulk NULLS FIRST;
