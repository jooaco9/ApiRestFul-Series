from sqlmodel import select
from api import GenreModel

# Controller de Generos
async def get_genres(db):
    # Creo la consulta
    stmt = select(GenreModel)

    results = db.exec(stmt)
    genres = results.all()
    return genres