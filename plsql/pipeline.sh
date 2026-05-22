#!/usr/bin/env bash
# pipeline.sh — Experimentos completos cursores vs BULK COLLECT
# Datasets: 1K, 10K, 100K, 1M, 10M facturas (x10 detalles)

set -euo pipefail

CONTAINER="oracle-plsql"
CONN="dev/Dev123@//localhost/XE"

# ─── Helpers ──────────────────────────────────────────────────────────────────

run_sql() {
    local file="$1"
    shift
    local args="${*:-}"
    local dest="/tmp/$(basename "$file")"
    docker cp "$file" "$CONTAINER":"$dest" 2>/dev/null
    docker exec -i "$CONTAINER" sqlplus -s "$CONN" <<EOF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
@$dest $args
EXIT;
EOF
}

separator() {
    echo ""
    echo "══════════════════════════════════════════════════════════"
    echo "  $1"
    echo "══════════════════════════════════════════════════════════"
}

# ─── Reset ────────────────────────────────────────────────────────────────────

separator "Borrando tablas anteriores..."
run_sql scripts/borrar_tablas.sql

separator "Creando tablas..."
run_sql scripts/crear_tablas.sql

# ─── Experimentos ─────────────────────────────────────────────────────────────
# PRINT: 1 = imprime filas (datasets pequenos), 0 = solo tiempo (datasets grandes)

for N_FACT in 1000 10000 100000 1000000 10000000; do

    separator "Dataset: $N_FACT facturas / $((N_FACT * 10)) detalles"

    echo ""
    echo ">>> Insertando datos..."
    run_sql scripts/insertar_datos.sql "$N_FACT"

    # Imprimir filas solo para datasets pequenos
    if [ "$N_FACT" -le 10000 ]; then PRINT=1; else PRINT=0; fi

    # LIMIT values segun tamano del dataset
    if   [ "$N_FACT" -le 1000 ];      then LIMITS="10 100 1000"
    elif [ "$N_FACT" -le 10000 ];     then LIMITS="100 1000 10000"
    elif [ "$N_FACT" -le 100000 ];    then LIMITS="1000 10000 100000"
    elif [ "$N_FACT" -le 1000000 ];   then LIMITS="10000 100000 1000000"
    else                                   LIMITS="100000 1000000 10000000"
    fi

    echo ""
    echo ">>> [a] Cursores simples (print=$PRINT)..."
    run_sql scripts/cursores.sql "$PRINT"

    for LIM in $LIMITS; do
        echo ""
        echo ">>> [b] Bulk COLLECT LIMIT $LIM (print=$PRINT)..."
        run_sql scripts/bulk.sql "$LIM" "$PRINT"
    done

done

# ─── Tabla comparativa ────────────────────────────────────────────────────────

separator "TABLA COMPARATIVA DE RESULTADOS"
run_sql scripts/ver_resultados.sql

echo ""
echo "Pipeline completado."
