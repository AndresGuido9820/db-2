BEGIN EXECUTE IMMEDIATE 'DROP TABLE Detalle_Factura CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Factura CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE resultados CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE Factura (
    codigo_factura  INT PRIMARY KEY,
    fecha           DATE,
    codigo_cliente  INT,
    codigo_vendedor INT
);

CREATE TABLE Detalle_Factura (
    codigo_detalle   INT PRIMARY KEY,
    codigo_factura   INT,
    codigo_producto  INT,
    numero_unidades  INT,
    precio_unitario  DECIMAL(11,3),
    FOREIGN KEY (codigo_factura) REFERENCES Factura(codigo_factura)
);

CREATE TABLE resultados (
    metodo_usado     VARCHAR2(50),
    tiempo_ejecucion NUMBER,
    numero_facturas  INT,
    numero_detalles  INT,
    limite_bulk      INT
);
