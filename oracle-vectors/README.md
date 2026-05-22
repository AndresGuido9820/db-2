# Punto 2 - Oracle Vector

Esta carpeta contiene la solución del Punto 2: insertar embeddings de 200 noticias en Oracle y ejecutar búsquedas vectoriales.

## Estructura

```text
oracle-vectors/
  start.sh                 levanta Oracle Vector
  stop.sh                  detiene Oracle Vector
  run_embed.sh             crea tablas e importa JSONs con embeddings
  run_query.sh             ejecuta un SQL contra Oracle
  docker-compose.yml       Oracle 23ai/26ai Free
  embeddings/              JSONs de noticias y consultas vectorizadas
  notebooks/               notebook de preparación de datos
  python/                  scripts de importación a Oracle
  sql/                     DDL y consultas vectoriales
  results/                 salidas capturadas
```

## Fuente oficial

El notebook `notebooks/embeddings_workflow.ipynb` documenta el flujo completo:

1. Descarga el dataset BBC News.
2. Filtra textos de 100 a 500 palabras.
3. Selecciona 200 noticias con `random_state=42`.
4. Genera embeddings con `sentence-transformers/all-MiniLM-L6-v2`.
5. Genera embeddings para 8 consultas.
6. Produce los JSON que se guardan en `embeddings/`.

## Levantar Oracle

```bash
./start.sh
```

El contenedor queda disponible en `localhost:1522`.

Credenciales:

| Usuario | Password | DSN |
| --- | --- | --- |
| `vec` | `Vec123` | `localhost:1522/FREEPDB1` |

## Cargar embeddings

```bash
./run_embed.sh
```

Este comando:

1. Crea un entorno virtual si no existe.
2. Instala dependencias desde `python/requirements.txt`.
3. Ejecuta `sql/01_schema.sql`.
4. Importa `embeddings/news_embeddings.json` con `python/import_news_embeddings.py`.
5. Importa `embeddings/query_embeddings.json` con `python/import_query_embeddings.py`.

## Ejecutar consultas

```bash
./run_query.sh
```

Equivale a:

```bash
./run_query.sh sql/02_vector_queries.sql
```

Para guardar la salida:

```bash
./run_query.sh sql/02_vector_queries.sql > results/query_output.txt
```

## Validación rápida

```bash
docker exec -i oracle-vectors sqlplus -S vec/Vec123@FREEPDB1 <<'SQL'
SELECT COUNT(*) AS news_count FROM news_articles;
SELECT COUNT(*) AS query_count FROM query_vectors;
EXIT;
SQL
```

Resultado esperado:

- `news_count = 200`
- `query_count = 8`

## Detener Oracle

```bash
./stop.sh
```

Los datos quedan persistidos en el volumen `oracle_vectors_data`. Para borrar también los datos:

```bash
docker compose down -v
```
