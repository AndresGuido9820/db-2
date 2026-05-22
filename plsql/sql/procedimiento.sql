-- Ejemplo: stored procedure con manejo de excepciones

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Crear o reemplazar el procedimiento
CREATE OR REPLACE PROCEDURE actualizar_salario(
    p_id        IN  empleados.id%TYPE,
    p_aumento   IN  NUMBER,        -- porcentaje, ej: 10 = +10%
    p_resultado OUT VARCHAR2
) AS
    v_salario_actual empleados.salario%TYPE;
BEGIN
    SELECT salario INTO v_salario_actual
    FROM   empleados
    WHERE  id = p_id;

    UPDATE empleados
    SET    salario = salario * (1 + p_aumento / 100)
    WHERE  id = p_id;

    COMMIT;

    p_resultado := 'OK: salario actualizado de ' ||
                   TO_CHAR(v_salario_actual, 'FM9,999,999') ||
                   ' a ' ||
                   TO_CHAR(v_salario_actual * (1 + p_aumento / 100), 'FM9,999,999');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_resultado := 'ERROR: empleado con id=' || p_id || ' no existe';
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR: ' || SQLERRM;
END actualizar_salario;
/

-- Ejecutar el procedimiento
DECLARE
    v_resultado VARCHAR2(200);
BEGIN
    actualizar_salario(1, 15, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);

    actualizar_salario(999, 10, v_resultado);   -- id inexistente
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
