-- Esquema inicial — se ejecuta automaticamente al primer arranque
-- Conectado como APP_USER (dev)

-- Tabla de ejemplo
CREATE TABLE empleados (
    id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre     VARCHAR2(100) NOT NULL,
    cargo      VARCHAR2(100),
    salario    NUMBER(10,2),
    fecha_alta DATE DEFAULT SYSDATE
);

-- Datos de prueba
INSERT INTO empleados (nombre, cargo, salario) VALUES ('Ana Torres',    'Ingeniera IIoT',   4500000);
INSERT INTO empleados (nombre, cargo, salario) VALUES ('Carlos Rios',   'Tecnico de Campo', 3200000);
INSERT INTO empleados (nombre, cargo, salario) VALUES ('Maria Gomez',   'Analista Datos',   3800000);
COMMIT;
