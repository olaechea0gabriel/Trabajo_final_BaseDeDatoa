from datetime import date
from typing import Optional
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.database import get_connection

router = APIRouter(prefix="/admision", tags=["1. Admisión (CRUD 3 Tablas)"])

class AdmisionCreate(BaseModel):
    dni: str
    nombres: str
    apellidos: str
    fcha_ncmnto: date
    sexo: str
    telefono: str
    correo_electronico: Optional[str] = None
    num_expediente: str
    observacion_gral: Optional[str] = None
    id_tipo_antecedente: int
    descripcion_antecedente: str

class PacienteUpdate(BaseModel):
    telefono: str
    correo_electronico: Optional[str] = None
    observacion_gral: str

@router.post("/registrar-paciente-completo", status_code=201)
def registrar_admision_completa(datos: AdmisionCreate):
    """
    CREATE (3 tablas vinculadas en SQL puro):
    1. Inserta PACIENTE -> obtiene id_paciente con RETURNING
    2. Inserta HISTORIA_CLINICA -> obtiene id_historia con RETURNING
    3. Inserta ANTECEDENTE clínico inicial
    """
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                # 1. Insertar Paciente
                cur.execute(
                    """
                    INSERT INTO PACIENTE (dni, nombres, apellidos, fcha_ncmnto, sexo, telefono, correo_electronico)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                    RETURNING id_paciente;
                    """,
                    (datos.dni, datos.nombres, datos.apellidos, datos.fcha_ncmnto,
                     datos.sexo.upper(), datos.telefono, datos.correo_electronico)
                )
                id_paciente = cur.fetchone()["id_paciente"]

                # 2. Insertar Historia Clínica vinculada
                cur.execute(
                    """
                    INSERT INTO HISTORIA_CLINICA (num_expediente, observacion_gral, id_paciente)
                    VALUES (%s, %s, %s)
                    RETURNING id_historia;
                    """,
                    (datos.num_expediente, datos.observacion_gral, id_paciente)
                )
                id_historia = cur.fetchone()["id_historia"]

                # 3. Insertar Antecedente inicial vinculado a la Historia
                cur.execute(
                    """
                    INSERT INTO ANTECEDENTE (descripcion, id_historia, id_tipo_antecedente)
                    VALUES (%s, %s, %s)
                    RETURNING id_antecedente;
                    """,
                    (datos.descripcion_antecedente, id_historia, datos.id_tipo_antecedente)
                )
                id_antecedente = cur.fetchone()["id_antecedente"]

            conn.commit()
        return {
            "mensaje": "Admisión registrada en las 3 tablas correctamente",
            "id_paciente": id_paciente,
            "id_historia": id_historia,
            "id_antecedente": id_antecedente
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error al registrar admisión: {str(e)}")

@router.get("/expediente/{dni}")
def consultar_expediente_por_dni(dni: str):
    """READ: Consulta consolidada con JOIN entre PACIENTE, HISTORIA_CLINICA, ANTECEDENTE y TIPO_ANTECEDENTE."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT p.id_paciente, p.dni, p.nombres, p.apellidos, p.telefono, p.correo_electronico,
                       h.id_historia, h.num_expediente, h.fcha_apertura, h.observacion_gral,
                       a.id_antecedente, ta.nombre_tipo AS tipo_antecedente, a.descripcion AS detalle_antecedente
                FROM PACIENTE p
                JOIN HISTORIA_CLINICA h ON p.id_paciente = h.id_paciente
                LEFT JOIN ANTECEDENTE a ON h.id_historia = a.id_historia
                LEFT JOIN TIPO_ANTECEDENTE ta ON a.id_tipo_antecedente = ta.id_tipo_antecedente
                WHERE p.dni = %s;
                """,
                (dni,)
            )
            filas = cur.fetchall()
    if not filas:
        raise HTTPException(status_code=404, detail="No se encontró paciente con ese DNI")
    return {"dni": dni, "registros": filas}

@router.put("/actualizar/{id_paciente}")
def actualizar_contacto_y_historia(id_paciente: int, datos: PacienteUpdate):
    """UPDATE: Actualiza datos de contacto en PACIENTE y observación en HISTORIA_CLINICA."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE PACIENTE SET telefono = %s, correo_electronico = %s WHERE id_paciente = %s RETURNING id_paciente;",
                (datos.telefono, datos.correo_electronico, id_paciente)
            )
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Paciente no encontrado")

            cur.execute(
                "UPDATE HISTORIA_CLINICA SET observacion_gral = %s WHERE id_paciente = %s;",
                (datos.observacion_gral, id_paciente)
            )
        conn.commit()
    return {"mensaje": f"Datos y expediente del paciente {id_paciente} actualizados"}

@router.delete("/eliminar/{id_paciente}")
def eliminar_paciente_en_cascada(id_paciente: int):
    """DELETE: Elimina al paciente y verifica el borrado en cascada (ON DELETE CASCADE) de su historia y antecedentes."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM PACIENTE WHERE id_paciente = %s RETURNING nombres, apellidos;", (id_paciente,))
            eliminado = cur.fetchone()
            if not eliminado:
                raise HTTPException(status_code=404, detail="Paciente no encontrado")
        conn.commit()
    return {"mensaje": f"Paciente {eliminado['nombres']} {eliminado['apellidos']} y registros asociados eliminados (ON DELETE CASCADE)"}
