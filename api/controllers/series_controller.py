from sqlmodel import select
from api import SerieModel, SerieSchema, GenreModel, SeriesGenresModel

# Controller de serie

# Funcion para armar la lista con las series y cada genero que tiene
def convert_to_series_dict(results):
    # Armo diccionario con cada serie con SerieSchema y agrego los generos
    series_dict = {}
    for serie, genre in results:
        # Si la serie no esta la agrego con id como clave
        if serie.id not in series_dict:
            series_dict[serie.id] = SerieSchema(
                id=serie.id,
                title=serie.title,
                description=serie.description,
                release_year=serie.release_year,
                cover_url=serie.cover_url,
                end_year=serie.end_year,
                genres=[]
            )
        # Agrego el genero a la serie
        series_dict[serie.id].genres.append(genre)

    # Retorno una lista pero de los valores del diccionario
    return list(series_dict.values())

# Funcion para obtener todas las series
async def get_series(db):
    # Consulta para obtener todas las series
    stmt = (
        select(SerieModel, GenreModel.name)
        .join(SeriesGenresModel, SerieModel.id == SeriesGenresModel.serie_id)
        .join(GenreModel, SeriesGenresModel.genre_id == GenreModel.id)
    )

    # Obtengo los resultados
    results = db.exec(stmt).all()

    # Devuelvo las series
    return convert_to_series_dict(results)


# Funcion parra obtener las series estrenadas despues del "anio"
async def get_series_anio(anio, db):
    # Consulta para obtener las series mayor al "anio"
    stmt = (
        select(SerieModel, GenreModel.name)
        .join(SeriesGenresModel, SerieModel.id == SeriesGenresModel.serie_id)
        .join(GenreModel, SeriesGenresModel.genre_id == GenreModel.id)
        .where(SerieModel.release_year >= anio)
    )

    # Obtengo los resultados
    results = db.exec(stmt).all()

    # Devuelvo las series
    return convert_to_series_dict(results)
