# Bases de Datos 2 - Trabajo 1

Repositorio con las dos partes del Trabajo 1:

- `plsql/`: comparación en Oracle PL/SQL entre cursores anidados y `BULK COLLECT`.
- `oracle-vectors/`: carga de noticias, embeddings y consultas vectoriales en Oracle 23ai/26ai Free.

## Requisitos

- Docker
- Docker Compose v2 (`docker compose`)
- Python 3.10 o superior
- Bash
- Acceso a internet solo si se quiere regenerar el notebook de embeddings desde cero

## Estructura

```text
plsql/
  docker-compose.yml        Oracle XE 21c para el Punto 1
  start.sh                  levanta Oracle PL/SQL
  stop.sh                   detiene Oracle PL/SQL
  run.sh                    ejecuta un archivo SQL
  pipeline.sh               corre los experimentos principales
  resultados/               salidas capturadas del Punto 1
  sql/
    crear_tablas.sql        crea Factura, Detalle_Factura y resultados
    insertar_datos.sql      carga facturas y detalles
    cursores.sql            solución con cursores anidados
    bulk.sql                solución con BULK COLLECT
    ver_resultados.sql      consulta tiempos guardados

oracle-vectors/
  docker-compose.yml        Oracle 23ai/26ai Free para vectores
  start.sh                  levanta Oracle Vector
  stop.sh                   detiene Oracle Vector
  run_embed.sh              crea tablas e importa embeddings
  run_query.sh              ejecuta consultas vectoriales
  embeddings/               JSONs con embeddings de noticias y consultas
  notebooks/                notebook oficial del flujo de datos
  python/                   importadores de JSON a Oracle
  sql/                      esquema y consultas vectoriales
  results/                  salida de consultas
```

## Punto 1: PL/SQL

Desde la carpeta `plsql`:

```bash
cd plsql
./start.sh
./pipeline.sh
```

La primera ejecución de `./start.sh` puede tardar varios minutos porque Docker descarga la imagen `gvenzl/oracle-xe:21-slim` e inicializa la base.

Para ejecutar un script específico:

```bash
cd plsql
./run.sh sql/crear_tablas.sql
./run.sh sql/insertar_datos.sql 10000
./run.sh sql/cursores.sql 0
./run.sh sql/bulk.sql 1000 0
```

Credenciales locales:

| Usuario | Password |
| --- | --- |
| `system` | `Oracle123` |
| `dev` | `Dev123` |

Validación rápida:

```bash
cd plsql
./run.sh sql/ejemplo_basico.sql
```

## Punto 2: Oracle Vector

Desde la carpeta `oracle-vectors`:

```bash
cd oracle-vectors
./start.sh
./run_embed.sh
./run_query.sh
```

La primera ejecución de `./start.sh` puede tardar varios minutos porque Docker descarga la imagen `gvenzl/oracle-free:23-slim` e inicializa Oracle Free.
`./run_embed.sh` crea `.venv/` e instala las dependencias de `oracle-vectors/python/requirements.txt`.

El notebook `oracle-vectors/notebooks/embeddings_workflow.ipynb` es la fuente principal del flujo de datos:

1. Descarga el dataset BBC News.
2. Filtra textos de 100 a 500 palabras.
3. Toma una muestra reproducible de 200 noticias.
4. Genera embeddings con `sentence-transformers/all-MiniLM-L6-v2`.
5. Genera embeddings para 8 consultas.
6. Produce el esquema y los inserts para Oracle Vector.

Credenciales locales:

| Usuario | Password | DSN |
| --- | --- | --- |
| `vec` | `Vec123` | `localhost:1522/FREEPDB1` |

Validación rápida:

```bash
cd oracle-vectors
docker exec -i oracle-vectors sqlplus -S vec/Vec123@FREEPDB1 <<'SQL'
SELECT COUNT(*) AS news_count FROM news_articles;
SELECT COUNT(*) AS query_count FROM query_vectors;
EXIT;
SQL
```

El resultado esperado es `news_count = 200` y `query_count = 8`.

## Resultados

Los archivos `plsql/resultados/exp_*.txt` guardan las salidas usadas en el informe del Punto 1.
Cada ejecución de `plsql/pipeline.sh` genera además un log `plsql/resultados/pipeline_YYYYMMDD_HHMMSS.txt`.

El archivo `oracle-vectors/results/query_output.txt` guarda la salida de las consultas vectoriales. Para regenerarlo:

```bash
cd oracle-vectors
./run_query.sh sql/02_vector_queries.sql > results/query_output.txt
```

## Limpieza

Detener los contenedores sin borrar datos:

```bash
cd plsql && ./stop.sh
cd ../oracle-vectors && ./stop.sh
```

Borrar datos persistidos de un módulo:

```bash
cd plsql && docker compose down -v
cd ../oracle-vectors && docker compose down -v
```
