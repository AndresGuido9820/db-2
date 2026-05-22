SET ECHO OFF
SET VERIFY OFF
SET PAGESIZE 60
SET LINESIZE 80
SET FEEDBACK ON
COLUMN id      FORMAT 999
COLUMN dist    FORMAT 9.9999
COLUMN snippet FORMAT A55 WORD_WRAPPED

-- =============================================================================
-- CONSULTA 1: Frase exacta - economia
-- "The impact of rising inflation and interest rates on the economy"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 1: Frase exacta - economia ===
PROMPT Texto: "The impact of rising inflation and interest rates on the economy"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 1 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 1 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 1 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 1 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 2: Emocion abstracta - tristeza
-- "A deep feeling of sadness, tragedy, and emotional loss"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 2: Emocion abstracta - tristeza ===
PROMPT Texto: "A deep feeling of sadness, tragedy, and emotional loss"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 2 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 2 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 2 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 2 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 3: Concepto general - animales
-- "Wild animals, endangered species, and nature conservation"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 3: Concepto general - animales ===
PROMPT Texto: "Wild animals, endangered species, and nature conservation"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 3 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 3 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 3 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 3 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 4: Consulta vaga
-- "Things are getting worse very quickly and people are complaining"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 4: Consulta vaga ===
PROMPT Texto: "Things are getting worse very quickly and people are complaining"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 4 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 4 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 4 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 4 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 5: Pregunta directa - cine
-- "Who won the best actor award at the film festival?"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 5: Pregunta directa - cine ===
PROMPT Texto: "Who won the best actor award at the film festival?"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 5 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 5 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 5 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 5 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 6: Concepto tecnico - innovacion
-- "Next generation digital software and mobile internet innovations"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 6: Concepto tecnico - innovacion ===
PROMPT Texto: "Next generation digital software and mobile internet innovations"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 6 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 6 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 6 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 6 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 7: Ensalada de palabras - politica
-- "Election parliament prime minister voting campaign"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 7: Ensalada de palabras - politica ===
PROMPT Texto: "Election parliament prime minister voting campaign"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 7 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 7 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 7 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 7 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

-- =============================================================================
-- CONSULTA 8: Fuera de contexto - frutas
-- "Tropical fruits like apples, bananas, and oranges"
-- =============================================================================
PROMPT
PROMPT === CONSULTA 8: Fuera de contexto - frutas ===
PROMPT Texto: "Tropical fruits like apples, bananas, and oranges"
PROMPT >> EXACTO
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 8 ORDER BY dist FETCH FIRST 10 ROWS ONLY;
PROMPT >> TARGET ACCURACY 90pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 8 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 90 PERCENT;
PROMPT >> TARGET ACCURACY 70pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 8 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 70 PERCENT;
PROMPT >> TARGET ACCURACY 50pct
SELECT n.id, ROUND(VECTOR_DISTANCE(n.embedding, q.embedding, COSINE), 4) AS dist, REGEXP_REPLACE(SUBSTR(CAST(n.content AS VARCHAR2(250)), 1, 200), '[[:space:]]+', ' ') AS snippet
FROM   news_articles n, query_vectors q WHERE q.id = 8 ORDER BY VECTOR_DISTANCE(n.embedding, q.embedding, COSINE) FETCH APPROXIMATE FIRST 10 ROWS ONLY WITH TARGET ACCURACY 50 PERCENT;

EXIT;
