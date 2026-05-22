SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE

cursor c_factura is
select * from Factura;

cursor c_detalle (p_codigo_factura int) is
select * from Detalle_Factura where codigo_factura = p_codigo_factura;

valor_total  Detalle_Factura.precio_unitario%type;
start_time   number;
last_time    number;
total_time   number;
v_print      pls_integer := nvl(&1, 1); -- 1 imprime filas, 0 solo tiempo

begin
start_time := dbms_utility.get_time;

for r1 in c_factura loop

    valor_total := 0;

    for r2 in c_detalle(r1.codigo_factura) loop
        valor_total := valor_total + (r2.numero_unidades * r2.precio_unitario);
    end loop;

    if v_print = 1 then
        dbms_output.put_line('| Factura: ' || r1.codigo_factura || ' | Fecha: ' || r1.fecha || ' | Cliente: ' || r1.codigo_cliente || ' | Vendedor: ' || r1.codigo_vendedor || ' | Total: ' || valor_total);
    end if;

end loop;

last_time  := dbms_utility.get_time;
total_time := (last_time - start_time) * 10;

dbms_output.put_line('--- Tiempo Cursores: ' || total_time || ' ms ---');

insert into resultados (metodo_usado, tiempo_ejecucion, numero_facturas, numero_detalles, limite_bulk)
values ('Cursor', total_time, (select count(*) from Factura), (select count(*) from Detalle_Factura), null);

commit;

end;
/
