from fastapi import APIRouter, status, Depends
from sqlalchemy.orm import Session

# DB
from api import get_db

# Modelos de DB
from api import SerieModel

# Controller
from api import serie_controller

# Enrutador para definir los endpoints
router = APIRouter()

@router.get("/", response_model=list[SerieModel], status_code=status.HTTP_200_OK)
async def get_series(db: Session = Depends(get_db)):
    return serie_controller.get_series(db)