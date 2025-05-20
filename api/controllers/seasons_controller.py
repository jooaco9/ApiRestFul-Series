from sqlmodel import select

from api import SeasonModel

async def get_seasons(db):
    # Creo la consulta
    stmt = select(SeasonModel)

    # Ejecuto la consulta
    results = db.exec(stmt)
    seasons = results.all()

    return seasons