-- Oracle 23ai Free  –  Vector Search schema
DROP TABLE IF EXISTS news_articles;
DROP TABLE IF EXISTS query_vectors;
SET DEFINE OFF;

CREATE TABLE news_articles (
    id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    content   CLOB,
    embedding VECTOR(384, FLOAT32)
);

CREATE TABLE query_vectors (
    id         NUMBER PRIMARY KEY,
    label      VARCHAR2(200),
    query_text VARCHAR2(500),
    embedding  VECTOR(384, FLOAT32)
);