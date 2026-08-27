from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_hello_returns_ok():
    response = client.get("/api/hello")
    assert response.status_code == 200
    assert response.json() == {"message": "hello"}


def test_root_returns_html():
    response = client.get("/")
    assert response.status_code == 200
    assert "text/html" in response.headers["content-type"]
