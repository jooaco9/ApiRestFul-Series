# Base de datos
from api.database.database import get_db

# Documentacion
from api.configdoc import tags_metadata

# Modelos DB
from api.models.serie_model import Serie as SerieModel

# Controladores
from api.controllers import serie_controller

# Rutas
from api.routers.series import router as serie_router

# App
from api.main import app