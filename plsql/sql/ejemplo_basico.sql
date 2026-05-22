-- Ejemplo basico de PL/SQL: bloque anonimo con cursor y logica condicional

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_nombre   empleados.nombre%TYPE;
    v_salario  empleados.salario%TYPE;
    v_nivel    VARCHAR2(20);

    CURSOR c_empleados IS
        SELECT nombre, salario
        FROM   empleados
        ORDER  BY salario DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Reporte de Empleados ===');
    DBMS_OUTPUT.PUT_LINE('----------------------------');

    OPEN c_empleados;
    LOOP
        FETCH c_empleados INTO v_nombre, v_salario;
        EXIT WHEN c_empleados%NOTFOUND;

        v_nivel := CASE
            WHEN v_salario >= 4000000 THEN 'SENIOR'
            WHEN v_salario >= 3500000 THEN 'MEDIO'
            ELSE                           'JUNIOR'
        END;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_nombre, 20) || ' | ' ||
            TO_CHAR(v_salario, 'FM9,999,999') || ' COP | ' ||
            v_nivel
        );
    END LOOP;
    CLOSE c_empleados;

    DBMS_OUTPUT.PUT_LINE('----------------------------');
    DBMS_OUTPUT.PUT_LINE('Fin del reporte.');
END;
/
