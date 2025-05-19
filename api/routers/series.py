from fastapi import APIRouter, status, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from typing_extensions import Annotated

# DB
from api import get_db

# Modelos de DB
from api import SerieModel

# Controller
from api import series_controller

# Enrutador para definir los endpoints
router = APIRouter()

# Endopoint para obtener todas las series
@router.get("/", response_model=list[SerieModel], status_code=status.HTTP_200_OK,
            summary="Obtiene todas las series"
            )
async def get_series(db: Session = Depends(get_db)):
    return await series_controller.get_series(db)

# Endpoint para obtener las series estrenadas despues de cierto año
@router.get("/release_year", response_model=list[SerieModel], status_code=status.HTTP_200_OK,
            summary="Obtiene series con filtro de años",
            description="""
                Devuelve todas las series las cuales se hayan estrenado despues del "anio" puesto como query parameter
            """
            )
async def get_series_anio(anio: Annotated[int, Query(description="A partir de que año se estrenaron", gt=1980)],
                          db: Session = Depends(get_db)):
    series_anio = await series_controller.get_series_anio(anio, db)

    if not series_anio:
        raise HTTPException(status_code=404, detail=f"No se encontraron series estrenadas despues del año {anio}")

    return series_anio















