from sqlmodel import select

# Schemas
from api import SerieSchema

# Modelos
from api import SerieModel, GenreModel, SeriesGenresModel, SeasonModel

# Controller de serie

# Funcion para armar la lista con las series y cada genero que tiene
def convert_to_series_dict(series_seasons_results, series_genres_results):
    # Armo diccionario con cada serie con SerieSchema y agrego los generos
    series_dict = {}
    for serie, number, season_id in series_seasons_results:
        # Si la serie no esta la agrego con id como clave
        if serie.id not in series_dict:
            series_dict[serie.id] = SerieSchema(
                id=serie.id,
                title=serie.title,
                description=serie.description,
                release_year=serie.release_year,
                cover_url=serie.cover_url,
                end_year=serie.end_year,
                genres=[],
                seasons=[]
            )
        # Agrego la temporada a la serie
        series_dict[serie.id].seasons.append(number)
    
    for serie_id, genre in series_genres_results:
        if serie_id in series_dict and genre not in series_dict[serie_id].genres:
            series_dict[serie_id].genres.append(genre)

    # Retorno una lista pero de los valores del diccionario
    return list(series_dict.values())

# Funcion para obtener todas las series
async def get_series(db):
    # Consulta para obtener todas las series
    series_seasons_stmt = (
        select(SerieModel, SeasonModel.number, SeasonModel.id)
        .join(SeasonModel, SerieModel.id == SeasonModel.serie_id)
    )
    series_seasons_results = db.exec(series_seasons_stmt).all()

    # Second query: Get series with their genres
    series_genres_stmt = (
        select(SerieModel.id, GenreModel.name)
        .join(SeriesGenresModel, SerieModel.id == SeriesGenresModel.serie_id)
        .join(GenreModel, SeriesGenresModel.genre_id == GenreModel.id)
    )
    series_genres_results = db.exec(series_genres_stmt).all()

    # Devuelvo las series
    return convert_to_series_dict(series_seasons_results, series_genres_results)


# Funcion parra obtener las series estrenadas despues del "anio"
async def get_series_anio(anio, db):
    # Consulta para obtener las series mayor al "anio"
    series_seasons_stmt = (
        select(SerieModel, SeasonModel.number, SeasonModel.id)
        .join(SeasonModel, SerieModel.id == SeasonModel.serie_id)
        .where(SerieModel.release_year >= anio)
    )
    series_seasons_results = db.exec(series_seasons_stmt).all()

    if not series_seasons_results:
        return None

    # Second query: Get series with their genres
    series_genres_stmt = (
        select(SerieModel.id, GenreModel.name)
        .join(SeriesGenresModel, SerieModel.id == SeriesGenresModel.serie_id)
        .join(GenreModel, SeriesGenresModel.genre_id == GenreModel.id)
        .where(SerieModel.release_year >= anio)

    )
    series_genres_results = db.exec(series_genres_stmt).all()

    if not series_genres_results:
        return None

    # Devuelvo las series
    return convert_to_series_dict(series_seasons_results, series_genres_results)
