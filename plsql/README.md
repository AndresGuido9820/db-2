# Punto 1 - PL/SQL

Esta carpeta contiene la solución del Punto 1 del trabajo: comparar cursores anidados contra `BULK COLLECT` en Oracle PL/SQL.

## Levantar Oracle

```bash
./start.sh
```

El contenedor usa Oracle XE 21c y queda disponible en `localhost:1521`.
La primera ejecución descarga la imagen Docker e inicializa el usuario `dev`; puede tomar varios minutos.

## Scripts principales

| Archivo | Uso |
| --- | --- |
| `sql/crear_tablas.sql` | Crea `Factura`, `Detalle_Factura` y `resultados`. |
| `sql/insertar_datos.sql` | Inserta N facturas y detalles asociados. |
| `sql/cursores.sql` | Ejecuta el método con cursores anidados. |
| `sql/bulk.sql` | Ejecuta el método con `BULK COLLECT LIMIT`. |
| `sql/ver_resultados.sql` | Muestra la tabla comparativa de tiempos. |

## Ejecutar todo el experimento

```bash
./pipeline.sh
```

El pipeline:

1. Borra y crea tablas.
2. Inserta datos por escenario.
3. Ejecuta cursores anidados.
4. Ejecuta `BULK COLLECT` con distintos `LIMIT`.
5. Imprime la tabla comparativa.

La salida completa de cada ejecución queda guardada automáticamente en:

```text
resultados/pipeline_YYYYMMDD_HHMMSS.txt
```

El pipeline completo incluye escenarios grandes hasta 10.000.000 de facturas. Si solo se quiere probar la instalación, use primero un script suelto:

```bash
./run.sh sql/ejemplo_basico.sql
```

## Ejecutar scripts sueltos

```bash
./run.sh sql/crear_tablas.sql
./run.sh sql/insertar_datos.sql 10000
./run.sh sql/cursores.sql 0
./run.sh sql/bulk.sql 1000 0
./run.sh sql/ver_resultados.sql
```

Algunos scripts reciben parámetros SQL*Plus. Ejemplos:

```bash
./run.sh sql/insertar_datos.sql 10000
./run.sh sql/cursores.sql 0
./run.sh sql/bulk.sql 1000 0
```

Si se ejecutan manualmente dentro de SQL*Plus:

```sql
@sql/insertar_datos.sql 10000
@sql/cursores.sql 0
@sql/bulk.sql 1000 0
```

Donde el segundo parámetro de `cursores.sql`/`bulk.sql` controla la impresión:

- `1`: imprime cada factura.
- `0`: mide sin imprimir filas.

## Dependencias

- Docker y Docker Compose v2.
- Bash.
- No requiere paquetes Python para el Punto 1.

## Detener Oracle

```bash
./stop.sh
```
