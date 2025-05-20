from sqlmodel import select
from api import SerieModel, SerieSchema, GenreModel, SeriesGenresModel

# Controller de serie

# Funcion para obtener todas las series
async def get_series(db):
    # Consulta para obtener todas las series
    stmt = (
        select(SerieModel, GenreModel.name)
        .join(SeriesGenresModel, SerieModel.id == SeriesGenresModel.serie_id)
        .join(GenreModel, SeriesGenresModel.genre_id == GenreModel.id)
    )
    results = db.exec(stmt).all()

    # Armo diccionario con cada serie con SerieSchema y agrego los generos
    series_dict = {}
    for serie, genre in results:
        # Si la serie no esta la agrego con id como clave
        if serie.id not in series_dict:
            series_dict[serie.id] = SerieSchema(
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

# Funcion parra obtener las series estrenadas despues del "anio"
async def get_series_anio(anio, db):
    # Consulta para obtener las series mayor al "anio"
    stmt = select(SerieModel).where(SerieModel.release_year >= anio)
    results = db.exec(stmt)
    series_anio = results.all()

    # Transformar los resultados al esquema SerieSchema
    return [SerieSchema(**serie.dict()) for serie in series_anio]
