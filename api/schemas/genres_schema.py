from sqlmodel import Field, SQLModel

# Modelo Serie
class Genre(SQLModel):
    name: str = Field(description="Nombre del genero")