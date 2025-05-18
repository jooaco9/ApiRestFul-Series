from sqlmodel import Session
from api import get_db

def test_database_connection():
    # Obtener la sesion de la base de datos
    try:
        # Llamo al generador para obtener la sessino
        db = next(get_db())
        assert isinstance(db, Session)

        # Ejecuta una consulta simple
        result = db.exec("SELECT 1").one()
        assert result[0] == 1
    except Exception as e:
        assert False, f"Error al conectar con la base de datos: {e}"