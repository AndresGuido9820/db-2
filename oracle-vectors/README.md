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
La primera ejecución descarga la imagen Docker e inicializa el usuario `vec`; puede tomar varios minutos.

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

Los JSON ya están incluidos en el repositorio. Por eso no es necesario ejecutar el notebook para cargar la base; el notebook solo se usa si se quieren regenerar la muestra y los embeddings.

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

## Dependencias Python

El archivo `python/requirements.txt` contiene las dependencias para los dos flujos:

| Paquete | Uso |
| --- | --- |
| `oracledb` | Conexión desde Python hacia Oracle. |
| `numpy` | Conversión de listas a `FLOAT32` para insertar vectores. |
| `pandas` | Preparación de datos en el notebook. |
| `sentence-transformers` | Generación de embeddings en el notebook. |

Si solo se cargan los JSON ya generados, los scripts de importación usan `oracledb` y `numpy`. `run_embed.sh` instala todo el archivo de requisitos para que el entorno también sirva al notebook.

## Validación rápida

```bash
./run_query.sh sql/02_vector_queries.sql > /tmp/oracle_vector_check.txt
```

Resultado esperado:

- El comando termina sin errores.
- La salida contiene resultados para las 8 consultas.

## Detener Oracle

```bash
./stop.sh
```

Los datos quedan persistidos en el volumen `oracle_vectors_data`. Para borrar también los datos:

```bash
docker compose down -v
```
