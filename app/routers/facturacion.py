import json
from typing import Any, Dict
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.database import get_connection

router = APIRouter(prefix="/facturacion", tags=["2. Facturación (ACID) y Psicométrica (JSONB)"])

class PagoTransaccion(BaseModel):
    serie_numero: str
    monto_total: float
    id_consulta: int
    id_forma_pago: int
    num_operacion: str | None = None

class EvaluacionJsonb(BaseModel):
    evaluacion_psicometrica: Dict[str, Any]

@router.post("/liquidar-consulta", status_code=201)
def liquidar_consulta_acid(datos: PagoTransaccion):
    """
    TRANSACCIÓN ACID EN SQL PURO:
    1. Inicia bloque transaccional explícito.
    2. Inserta en COMPROBANTE.
    3. Inserta en PAGO.
    4. Actualiza CITA a estado 3 ('Atendida').
    Si cualquier paso falla (ej. monto <= 0 o consulta ya facturada), ejecuta ROLLBACK total.
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("BEGIN;")

            # 1. Crear comprobante
            cur.execute(
                """
                INSERT INTO COMPROBANTE (serie_numero, monto_total, id_consulta)
                VALUES (%s, %s, %s)
                RETURNING id_comprobante;
                """,
                (datos.serie_numero, datos.monto_total, datos.id_consulta)
            )
            id_comprobante = cur.fetchone()["id_comprobante"]

            # 2. Registrar pago vinculado
            cur.execute(
                """
                INSERT INTO PAGO (monto_abonado, num_operacion, id_comprobante, id_forma_pago)
                VALUES (%s, %s, %s, %s)
                RETURNING id_pago;
                """,
                (datos.monto_total, datos.num_operacion, id_comprobante, datos.id_forma_pago)
            )
            id_pago = cur.fetchone()["id_pago"]

            # 3. Marcar cita como 'Atendida' (id_estado = 3)
            cur.execute(
                """
                UPDATE CITA
                SET id_estado = 3
                WHERE id_cita = (SELECT id_cita FROM CONSULTA WHERE id_consulta = %s);
                """,
                (datos.id_consulta,)
            )

            cur.execute("COMMIT;")
        return {
            "mensaje": "Transacción ACID completada (COMMIT): Comprobante, Pago y Estado de Cita actualizados",
            "id_comprobante": id_comprobante,
            "id_pago": id_pago
        }
    except Exception as e:
        conn.rollback()
        raise HTTPException(
            status_code=400,
            detail=f"Transacción revertida (ROLLBACK ejecutado). Motivo: {str(e)}"
        )
    finally:
        conn.close()

@router.patch("/consultas/{id_consulta}/evaluacion-jsonb")
def registrar_evaluacion_psicometrica(id_consulta: int, datos: EvaluacionJsonb):
    """HÍBRIDO JSONB: Guarda estructuras variables de tests psicológicos (PHQ-9, GAD-7, etc.)."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                UPDATE CONSULTA
                SET evaluacion_psicometrica = %s::jsonb
                WHERE id_consulta = %s
                RETURNING id_consulta, diagnostico_ppal, evaluacion_psicometrica;
                """,
                (json.dumps(datos.evaluacion_psicometrica), id_consulta)
            )
            actualizado = cur.fetchone()
            if not actualizado:
                raise HTTPException(status_code=404, detail="Consulta no encontrada")
        conn.commit()
    return actualizado

@router.get("/consultas/buscar-por-escala")
def buscar_consultas_por_jsonb(escala: str, puntaje_minimo: int = 10):
    """HÍBRIDO JSONB: Filtra usando operadores nativos ->> e índice GIN."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT c.id_consulta, c.fcha_consulta, p.nombres || ' ' || p.apellidos AS paciente,
                       c.diagnostico_ppal, c.evaluacion_psicometrica
                FROM CONSULTA c
                JOIN CITA ci ON c.id_cita = ci.id_cita
                JOIN PACIENTE p ON ci.id_paciente = p.id_paciente
                WHERE c.evaluacion_psicometrica->>'escala' = %s
                  AND (c.evaluacion_psicometrica->>'puntaje_total')::int >= %s;
                """,
                (escala, puntaje_minimo)
            )
            resultados = cur.fetchall()
    return {"escala_buscada": escala, "puntaje_minimo": puntaje_minimo, "resultados": resultados}
