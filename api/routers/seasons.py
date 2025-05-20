from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing_extensions import Annotated

# DB
from api import get_db

# Modelo
from api import SeasonModel

# Controller
from api import seasons_controller

router = APIRouter()

@router.get("", response_model=list[SeasonModel], status_code=200,
            summary="Devuelve todas las temporadas"
            )
async def get_seasons(db: Session = Depends(get_db)):
    seasons = await seasons_controller.get_seasons(db)

    if not seasons:
        raise HTTPException(status_code=404, detail="No hay generos disponibles")
    
    return seasons

