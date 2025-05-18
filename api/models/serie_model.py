from sqlmodel import Field, SQLModel

# Modelo Serie
class Serie(SQLModel, table=True):
    __tablename__ = "series"

    id: int = Field(primary_key=True)
    title: str
    description: str
    release_year: int
    cover_url: str