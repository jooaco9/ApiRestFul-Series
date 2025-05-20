from sqlmodel import SQLModel, Field
from typing import List

# Modelo Serie
class Serie(SQLModel):
    id: int = Field(description="Id de la serie")
    title: str = Field(description="Titulo de la serie")
    description: str = Field(description="Descripcion de la serie")
    release_year: int = Field(description="Anio de la fecha de salida de la serie")
    cover_url: str = Field(description="URL de la foto de la serie")
    end_year: int | None = Field(description="Año en el que finalizo la serie, puede ser NULL si esta no está terminada")
    genres: List[str] = Field(description="Lista con todos los generos de la serie")
    seasons: List[int] = Field(description="Temporadas que tiene la serie")
