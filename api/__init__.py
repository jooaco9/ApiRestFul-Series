# Base de datos
from api.database.database import get_db

# Documentacion
from api.configdoc import tags_metadata

# Modelos DB
from api.models.serie_model import Serie as SerieModel
from api.models.seriesgenres_model import SeriesGenres as SeriesGenresModel
from api.models.genre_model import Genre as GenreModel
from api.models.season_model import Season as SeasonModel

# Schemas
from api.schemas.serie_schema import Serie as SerieSchema

# Controladores
from api.controllers import series_controller
from api.controllers import genres_controller
from api.controllers import seasons_controller

# Rutas
from api.routers.series import router as serie_router
from api.routers.genres import router as genre_router
from api.routers.seasons import router as season_router

# App
from api.main import app