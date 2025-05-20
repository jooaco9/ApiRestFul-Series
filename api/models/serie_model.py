from sqlmodel import Field, SQLModel

# Modelo Serie
class Serie(SQLModel, table=True):
    __tablename__ = "series"

    id: int = Field(primary_key=True, description="Id para la serie en la base de datos")
    title: str = Field(description="Titulo de la serie")
    description: str = Field(description="Descripcion de la serie")
    release_year: int = Field(description="Anio de la fecha de salida de la serie")
    cover_url: str = Field(description="URL de la foto de la serie")
    end_year: int = Field(description="Año en el que finalizo la serie, puede ser NULL si esta no está terminada")

