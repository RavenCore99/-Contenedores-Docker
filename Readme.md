# 🐳 Infraestructura de Servidores con Docker, FastAPI y Nginx

![Estado](https://img.shields.io/badge/Estado-Completado-success)
![Docker](https://img.shields.io/badge/Docker-29.9.2-blue?logo=docker)
![Python](https://img.shields.io/badge/Python-3.11-yellow?logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-Framework-green?logo=fastapi)
![Nginx](https://img.shields.io/badge/Nginx-Balanceador-orange?logo=nginx)
![Licencia](https://img.shields.io/badge/Licencia-MIT-lightgrey)

**Descripción breve:**
Este proyecto despliega una arquitectura de microservicios utilizando Docker Compose. Consiste en tres instancias independientes de una API REST (construida con Python y FastAPI) y un servidor Nginx que actúa como proxy inverso y balanceador de carga. Resuelve el problema de la alta disponibilidad, evitando la saturación de un solo servidor y distribuyendo equitativamente el tráfico web.

## Tabla de Contenidos
- [Instalación](#-instalación)
- [Uso](#-uso)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Contacto](#-contacto)

## Instalación

### 1. Requisitos Previos
Para ejecutar este proyecto, necesitas tener un sistema operativo Windows 10/11 (o Mac/Linux) con los siguientes componentes:
* Docker Desktop (versión 4.0 o superior).
* WSL 2 (Subsistema de Windows para Linux) actualizado (solo Windows).
* Visual Studio Code (recomendado para editar el código).

### 2. Instalación del Entorno (Windows)
Si es la primera vez que instalas Docker en Windows, sigue estos pasos cruciales para evitar errores de conexión:

Paso A: Habilitar la Plataforma de Máquina Virtual
Abre PowerShell como Administrador y ejecuta:
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All
(Reinicia el equipo al finalizar).

Paso B: Instalar Docker Desktop
Puedes descargarlo desde la página oficial o usar el gestor de paquetes de Windows (PowerShell como administrador):
winget install -e --id Docker.DockerDesktop

Paso C: Actualizar WSL
Para que Docker Desktop funcione correctamente, el subsistema de Linux debe estar actualizado. Abre PowerShell y ejecuta:
wsl --update
(Reinicia el equipo y asegúrate de que el ícono de la ballena de Docker esté en verde y diga "Engine running").

### 3. Variables de Entorno
El proyecto utiliza variables de entorno para diferenciar las instancias de los servidores. Estas se definen directamente en el archivo compose.yaml, por lo que no necesitas crear un archivo .env.

La API lee la variable SERVIDOR:
* Para el contenedor 1: SERVIDOR=Servidor 1
* Para el contenedor 2: SERVIDOR=Servidor 2
* Para el contenedor 3: SERVIDOR=Servidor 3

### 4. Pasos para Instalar y Construir
1. Clona este repositorio o descarga la carpeta del proyecto.
2. Abre una terminal en la carpeta raíz del proyecto (donde está el archivo compose.yaml).
3. Ejecuta el siguiente comando para descargar las imágenes y construir los contenedores:
(docker compose up --build -d)

## Uso

Una vez que los contenedores estén corriendo (puedes verificarlo con (docker ps)), accede a los siguientes servicios desde tu navegador:

* Balanceador de Carga (Ruta Principal): Abre http://localhost:8080/. Ejemplo práctico: Recarga la página (F5) varias veces. Verás cómo el mensaje JSON alterna entre los 3 servidores (Hola desde el Servidor 1, Servidor 2, Servidor 3), demostrando el algoritmo Round Robin.
* Documentación Interactiva (Swagger UI): Abre http://localhost:8080/docs. Aquí podrás ver la interfaz gráfica autogenerada por FastAPI, donde puedes hacer clic en "Try it out" y ejecutar las peticiones.
* Ruta de Salud (Health Check): Abre http://localhost:8080/salud para verificar el estado del servidor que responde.

Comando principal para apagar la infraestructura:
docker compose down

## Estructura del Proyecto

Practica_Servidores_Docker/
│
├── app.py               # Código de la API REST en FastAPI
├── Dockerfile           # Receta para construir la imagen de Python
├── compose.yaml         # Orquestación de los 3 servidores y el balanceador
│
└── nginx/
    └── nginx.conf       # Configuración del upstream y balanceo de carga


## Contacto / Créditos

* Autor Principal: [Yecid Villamil]
* Institución: Universidad de Cundinamarca - Ingeniería de Sistemas y Computación.
* Curso: Redes y Comunicación (CADI).
* Enlace al Repositorio: [Pega aquí el enlace a tu GitHub si lo subes]
* Documentación Externa:
  * Documentación Oficial de Docker: https://docs.docker.com/
  * Documentación Oficial de FastAPI: https://fastapi.tiangolo.com/
  * Documentación Oficial de Nginx: https://nginx.org/en/docs/