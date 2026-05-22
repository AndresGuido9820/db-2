-- Uso: @bulk.sql <LIMIT>   ej: @bulk.sql 100
-- El LIMIT controla cuantas filas se cargan por lote en BULK COLLECT
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE

type factura_type is table of Factura%rowtype;
type detalle_type is table of Detalle_Factura%rowtype;

factura_tab  factura_type;
detalle_tab  detalle_type;

valor_total  number;
start_time   number;
last_time    number;
total_time   number;
v_limit      pls_integer := &1;
v_print      pls_integer := nvl(&2, 1); -- 1 imprime filas, 0 solo tiempo

cursor c_factura is select * from Factura order by codigo_factura;

begin
start_time := dbms_utility.get_time;

open c_factura;
loop
    fetch c_factura bulk collect into factura_tab limit v_limit;
    exit when factura_tab.count = 0;

    for i in 1..factura_tab.count loop

        valor_total := 0;

        select * bulk collect into detalle_tab
        from Detalle_Factura
        where codigo_factura = factura_tab(i).codigo_factura;

        for j in 1..detalle_tab.count loop
            valor_total := valor_total + (detalle_tab(j).numero_unidades * detalle_tab(j).precio_unitario);
        end loop;

        if v_print = 1 then
            dbms_output.put_line('| Factura: ' || factura_tab(i).codigo_factura || ' | Fecha: ' || factura_tab(i).fecha || ' | Cliente: ' || factura_tab(i).codigo_cliente || ' | Vendedor: ' || factura_tab(i).codigo_vendedor || ' | Total: ' || valor_total);
        end if;

    end loop;
end loop;
close c_factura;

last_time  := dbms_utility.get_time;
total_time := (last_time - start_time) * 10;

dbms_output.put_line('--- Tiempo Bulk LIMIT ' || v_limit || ': ' || total_time || ' ms ---');

insert into resultados (metodo_usado, tiempo_ejecucion, numero_facturas, numero_detalles, limite_bulk)
values ('Bulk LIMIT ' || v_limit, total_time, (select count(*) from Factura), (select count(*) from Detalle_Factura), v_limit);

commit;

end;
/
