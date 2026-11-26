import csv
import io
from fastapi import APIRouter
from fastapi.responses import StreamingResponse
from app.database import get_connection

router = APIRouter(prefix="/reportes", tags=["3. Reportes (GROUP BY / HAVING y CSV)"])

@router.get("/productividad-psiquiatras")
def reporte_productividad_psiquiatras(ingreso_minimo: float = 0.0):
    """
    AGREGACIONES EN SQL PURO:
    Calcula total de consultas atendidas, monto recaudado y ticket promedio por psiquiatra
    usando JOIN, COUNT, SUM, AVG, GROUP BY y HAVING.
    """
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT ps.cmp,
                       ps.nombres || ' ' || ps.apellidos AS psiquiatra,
                       e.nombre_esp AS especialidad,
                       COUNT(co.id_consulta) AS total_consultas,
                       COALESCE(SUM(cb.monto_total), 0)::numeric(10,2) AS ingresos_totales,
                       COALESCE(ROUND(AVG(cb.monto_total), 2), 0)::numeric(10,2) AS ticket_promedio
                FROM PSIQUIATRA ps
                JOIN ESPECIALIDAD e ON ps.id_especialidad = e.id_especialidad
                LEFT JOIN CITA ci ON ps.id_psiquiatra = ci.id_psiquiatra
                LEFT JOIN CONSULTA co ON ci.id_cita = co.id_cita
                LEFT JOIN COMPROBANTE cb ON co.id_consulta = cb.id_consulta
                GROUP BY ps.id_psiquiatra, ps.cmp, ps.nombres, ps.apellidos, e.nombre_esp
                HAVING COALESCE(SUM(cb.monto_total), 0) >= %s
                ORDER BY ingresos_totales DESC;
                """,
                (ingreso_minimo,)
            )
            filas = cur.fetchall()
    return {"filtro_ingreso_minimo": ingreso_minimo, "reporte": filas}

@router.get("/productividad-psiquiatras/csv")
def exportar_productividad_csv(ingreso_minimo: float = 0.0):
    """EXPORTACIÓN CSV: Genera y descarga un archivo .csv directo desde la consulta SQL agregada."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT ps.cmp,
                       ps.nombres || ' ' || ps.apellidos AS psiquiatra,
                       e.nombre_esp AS especialidad,
                       COUNT(co.id_consulta) AS total_consultas,
                       COALESCE(SUM(cb.monto_total), 0)::numeric(10,2) AS ingresos_totales,
                       COALESCE(ROUND(AVG(cb.monto_total), 2), 0)::numeric(10,2) AS ticket_promedio
                FROM PSIQUIATRA ps
                JOIN ESPECIALIDAD e ON ps.id_especialidad = e.id_especialidad
                LEFT JOIN CITA ci ON ps.id_psiquiatra = ci.id_psiquiatra
                LEFT JOIN CONSULTA co ON ci.id_cita = co.id_cita
                LEFT JOIN COMPROBANTE cb ON co.id_consulta = cb.id_consulta
                GROUP BY ps.id_psiquiatra, ps.cmp, ps.nombres, ps.apellidos, e.nombre_esp
                HAVING COALESCE(SUM(cb.monto_total), 0) >= %s
                ORDER BY ingresos_totales DESC;
                """,
                (ingreso_minimo,)
            )
            filas = cur.fetchall()

    buffer = io.StringIO()
    writer = csv.writer(buffer)
    writer.writerow(["CMP", "Psiquiatra", "Especialidad", "Total_Consultas", "Ingresos_Totales_PEN", "Ticket_Promedio_PEN"])

    for f in filas:
        writer.writerow([
            f["cmp"], f["psiquiatra"], f["especialidad"],
            f["total_consultas"], f["ingresos_totales"], f["ticket_promedio"]
        ])

    buffer.seek(0)
    return StreamingResponse(
        iter([buffer.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=reporte_productividad_psiquiatras.csv"}
    )
