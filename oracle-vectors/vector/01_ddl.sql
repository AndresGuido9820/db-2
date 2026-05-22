-- Oracle 23ai Free  –  Vector Search schema
-- Run as user VEC (or SYSTEM)

DROP TABLE IF EXISTS news_articles;

CREATE TABLE news_articles (
    id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title     VARCHAR2(400),
    topic     VARCHAR2(100),
    content   CLOB,
    embedding VECTOR(384, FLOAT32)          -- all-MiniLM-L6-v2 output dim
);

-- Optional index for approximate vector search (IVF)
-- Uncomment after inserting all rows:
-- CREATE VECTOR INDEX news_vidx ON news_articles (embedding)
-- ORGANIZATION NEIGHBOR PARTITIONS
-- WITH DISTANCE COSINE;
