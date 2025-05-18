from fastapi.testclient import TestClient
from api import app

# Genero test de cliente
client = TestClient(app)

# Test del endpoint GET / series
def test_get_series():
    response = client.get("/series")

    assert response.status_code == 200
    assert len(response.json()) > 0

# Test del endpoint GET / series/release_year, bien
def test_get_series_anio_ok():
    response = client.get("/series/release_year?anio=2010")

    assert response.status_code == 200
    assert len(response.json()) > 0

# Test del endpoint GET / series/release_year, con anio incorrecto
def test_get_series_bad_anio():
    response = client.get("/series/release_year?anio=1900")
    error = {
        "error": "Input should be greater than 1980",
        "dato_enviado": "1900"
    }

    assert response.status_code == 404
    assert response.json() == error

# Test del endpoint GET / series/release_year, sin series despues de anio
def test_get_series_anio_empty():
    response = client.get("/series/release_year?anio=2050")
    error = {
        "error": "No se encontraron series estrenadas despues del año 2050"
    }

    assert response.status_code == 404
    assert response.json() == error








