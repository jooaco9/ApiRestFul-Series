from fastapi import APIRouter, status, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from typing_extensions import Annotated

# DB
from api import get_db

# Modelos de DB
from api import GenreModel

# Controller
from api import genres_controller

# Enrutador para definir los endpoints
router = APIRouter()

# Endpoint para obtener todos los generos
@router.get("", response_model=list[GenreModel], status_code=status.HTTP_200_OK,
            summary="Obtiene todos los generos"
            )
async def get_genres(db: Session = Depends(get_db)):
    genres = await genres_controller.get_genres(db)

    if not genres:
        raise HTTPException(status_code=404, detail="No hay generos disponibles")
    
    return genres