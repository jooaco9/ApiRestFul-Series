from sqlmodel import select
from api import SerieModel

# Controller de serie

# Funcion para obtener todas las series
async def get_series(db):
    # Creo la consulta
    stmt = select(SerieModel)

    # Listo las series
    results = db.exec(stmt)
    series = results.all()
    return series

# Funcion parra obtener las series estrenadas despues del "anio"
async def get_series_anio(anio, db):
    # Consulta para tomar las series mayor al "anio"
    stmt = select(SerieModel).where(SerieModel.release_year >= anio)

    # Obtengo las series
    results = db.exec(stmt)
    series_anio = results.all()
    return series_anio
