from fastapi import FastAPI, HTTPException
from app.database import get_connection
from app.routers import admision, facturacion

app = FastAPI(
    title="SGI MenteSana - API Consultorio Psiquiátrico",
    description="Backend en FastAPI con SQL Puro (psycopg) para Base de Datos I - UCSP",
    version="1.0.0"
)

app.include_router(admision.router)
app.include_router(facturacion.router)

@app.get("/", tags=["Estado"])
def verificar_conexion():
    """Verifica que FastAPI esté conectado a PostgreSQL ejecutando SQL puro."""
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT current_database() AS bd, COUNT(*) AS total_pacientes FROM PACIENTE;")
                resultado = cur.fetchone()
        return {
            "estado": "Conectado exitosamente",
            "base_de_datos": resultado["bd"],
            "pacientes_registrados": resultado["total_pacientes"]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error de conexión a PostgreSQL: {str(e)}")
