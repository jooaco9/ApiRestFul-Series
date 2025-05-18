from sqlmodel import select
from api import SerieModel

# Controller de serie
def get_series(db):
    # Creo la consulta
    stmt = select(SerieModel)

    # Listo las series
    results = db.exec(stmt)
    series = results.all()
    return series