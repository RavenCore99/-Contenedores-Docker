import os
from fastapi import FastAPI

app = FastAPI()

SERVER_NAME = os.getenv("SERVIDOR", "Servidor Desconocido")

@app.get("/")
def read_root():
    return {"mensaje": f"Hola desde el {SERVER_NAME}. El servidor está funcionando correctamente."}

@app.get("/salud")
def health_check():
    return {"estado": "OK", "servidor": SERVER_NAME}