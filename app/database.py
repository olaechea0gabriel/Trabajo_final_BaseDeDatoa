import os
import psycopg
from psycopg.rows import dict_row

DB_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://psiq_final_db:password123@localhost:5432/consultorio_db"
)

def get_connection():
    return psycopg.connect(DB_URL, row_factory=dict_row)
