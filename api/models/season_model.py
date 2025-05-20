from sqlmodel import SQLModel, Field

class Season(SQLModel, table=True):
    __tablename__ = "seasons"

    id: int = Field(primary_key=True, description="Id de la season")
    serie_id: int = Field(foreign_key="series.id", primary_key=True, description="Id de la serie de la cual es la season")
    number: int = Field(description="Numero de la season")