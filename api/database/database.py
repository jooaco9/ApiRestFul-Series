from sqlmodel import create_engine, Session

# Creacion del Engine contra la DB
SQLALCHEMY_DATABASE_URL = 'mysql+pymysql://root@localhost/seriesdb'
engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)

# Dependencia
def get_db():
    # Creo la session
    db = Session(engine)

    # Intento devolver la session
    try:
        yield db
    finally:
        # Cierro la session al final el proceso
        db.close()