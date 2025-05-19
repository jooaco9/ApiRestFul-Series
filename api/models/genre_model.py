from sqlmodel import Field, SQLModel

# Modelo Serie
class Genre(SQLModel, table=True):
    __tablename__ = "genres"

    id: int = Field(primary_key=True, description="Id del genero en la base de datos")
    name: str = Field(description="Nombre del genero")