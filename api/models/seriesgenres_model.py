from sqlmodel import Field, SQLModel

# Modelo Serie
class SeriesGenres(SQLModel, table=True):
    __tablename__ = "seriesgenres"

    genre_id: int = Field(foreign_key="genres.id", primary_key=True, description="Id del genero")
    serie_id: int = Field(foreign_key="series.id", primary_key=True, description="Id de la serie")