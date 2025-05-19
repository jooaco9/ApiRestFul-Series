from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Manejo de errores
from starlette.exceptions import HTTPException as StarletteHTTPException
from fastapi.exceptions import RequestValidationError
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse

# Routers
from api import serie_router
from api import genre_router

# Documentacion
from api import tags_metadata

# Configuracion de origins permitidos
origins = [
    "http://127.0.0.1:5500"
]

# Apirestful con FastApi
app = FastAPI(
    title="Seriesboxd API",
    description="ApiRestFul para la gestion de series de TV",
    version="0.1",
    contact={
        "name": "Joaquin Corbo",
        "email": "joaquin.corbo9@gmail.com"
    },
    license_info={
        "name": "Apache 2.0",
        "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
    },
    openapi_tags=tags_metadata
)

# Configuracion de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# IMPORTACION DE RUTAS

# Ruta para las series
app.include_router(
    serie_router,
    tags=["series"],
    prefix="/series"
)

# Ruta para los generos
app.include_router(
    genre_router,
    tags=["generos"],
    prefix="/generos"
)

# Manejo de EXCEPCIONES
@app.exception_handler(StarletteHTTPException)
async def http_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content=jsonable_encoder({"error": exc.detail})
    )

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request, exc: RequestValidationError):
    # Conversion dict
    error_dict = eval(str(exc))

    if error_dict[0]['type'] == "greater_than_equal":
        code_error = 422
    else:
        code_error = 404
    return JSONResponse(
        status_code=code_error,
        content=jsonable_encoder(
            {
                "error": error_dict[0]["msg"],
                "dato_enviado": error_dict[0]['input']
            }
        )
    )