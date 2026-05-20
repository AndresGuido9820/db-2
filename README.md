# DB 2

Repositorio de trabajos y ejercicios de la materia Base de Datos 2.

## Requisitos

- Docker
- Docker Compose

## Uso

**Levantar Oracle:**
```bash
./start.sh
```

**Correr tu script:**
```bash
bash correr.sh
```

**Correr cualquier archivo SQL:**
```bash
./run.sh scripts/mi_script.sql
```

**Detener Oracle:**
```bash
./stop.sh
```

## Estructura

```
scripts/        # Scripts PL/SQL
init/           # Schema inicial (se carga automatico al primer arranque)
correr.sh       # Corre scripts/mi_script.sql
run.sh          # Corre cualquier archivo SQL
start.sh        # Levanta el contenedor Oracle
stop.sh         # Detiene el contenedor
```

## Credenciales Oracle (local)

| Usuario  | Password  |
|----------|-----------|
| `system` | `sento123` |
| `dev`    | `Dev123`  |
