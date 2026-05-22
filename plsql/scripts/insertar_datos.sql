-- Uso: @insertar_datos.sql <N_FACTURAS>   ej: @insertar_datos.sql 1000
-- Trunca las tablas e inserta N facturas con ~10 detalles cada una
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

TRUNCATE TABLE Detalle_Factura;
TRUNCATE TABLE Factura;

DECLARE
    TYPE t_precios IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_precios      t_precios;
    n_facturas     INT := &1;
    v_detalle_id   INT := 1;
    v_num_det      INT;
    v_producto     INT;
    v_unidades     INT;
    v_precio       NUMBER(11,3);
    v_fecha        DATE;
    v_cliente      INT;
    v_vendedor     INT;
BEGIN
    FOR p IN 1..100 LOOP
        v_precios(p) := ROUND((5000 + (p * 4950)), 3);
    END LOOP;

    FOR i IN 1..n_facturas LOOP
        v_fecha    := DATE '2023-01-01' + MOD(i * 7 + 13, 730);
        v_cliente  := MOD(i * 3 + 7, 200) + 1;
        v_vendedor := MOD(i + 2, 20) + 1;

        INSERT INTO Factura (codigo_factura, fecha, codigo_cliente, codigo_vendedor)
        VALUES (i, v_fecha, v_cliente, v_vendedor);

        v_num_det := 8 + MOD(i, 5);

        FOR j IN 1..v_num_det LOOP
            v_producto  := MOD(v_detalle_id * 3 + j, 100) + 1;
            v_unidades  := MOD(v_detalle_id + j, 20) + 1;
            v_precio    := v_precios(v_producto);

            INSERT INTO Detalle_Factura
                (codigo_detalle, codigo_factura, codigo_producto, numero_unidades, precio_unitario)
            VALUES
                (v_detalle_id, i, v_producto, v_unidades, v_precio);

            v_detalle_id := v_detalle_id + 1;
        END LOOP;

        IF MOD(i, 1000) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('  ' || i || ' / ' || n_facturas || ' facturas insertadas...');
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Listo: ' || n_facturas || ' facturas, ' || (v_detalle_id - 1) || ' detalles.');
END;
/
