# 🐳 Servidores Docker: FastAPI + Nginx

Práctica de Redes y Comunicación de la Universidad de Cundinamarca. Se despliegan dos APIs en la fase inicial y se incorpora una tercera en la ampliación; Nginx distribuye las solicitudes por `localhost:8080`. El lanzador presenta el estado de cada fase con spinners Rich y una tabla de diez solicitudes. No muestra porcentajes falsos de construcción.

## Requisitos

- Docker Engine con `docker compose` disponible y ejecutándose. En Windows puede usarse Docker Desktop con WSL 2; en Linux no hace falta Docker Desktop.
- Python 3.11+ con `venv` y `pip` (en Windows, `py -3` o `python`).
- Puerto 8080 libre. Los scripts crean `.venv` local e instalan Typer y Rich; no instalan paquetes globalmente. La primera construcción de imágenes requiere acceso a Internet.

## Iniciar y detener

Los scripts usan la carpeta donde están los archivos (no una ruta fija), así que puedes clonar o copiar el proyecto en cualquier ubicación.

Desde la raíz del clon, en **Linux**:

```bash
./iniciar.sh --servidores 2   # fase 1: dos servidores
# Ctrl+C para detener; luego, por separado:
./iniciar.sh --servidores 3   # ampliación: tres servidores (también es el valor predeterminado)
```

En **Windows** (CMD, PowerShell o doble clic), use **`iniciar.cmd`** (también vale `activar.cmd`). No necesita `Set-ExecutionPolicy`: el `.cmd` arranca el preparador con `-ExecutionPolicy Bypass` solo para esa ejecución.

```bat
iniciar.cmd --servidores 2
:: Ctrl+C; después:
iniciar.cmd --servidores 3
```

`iniciar.cmd` / `scripts\windows\preparar.ps1`:
- trabaja siempre desde la carpeta del proyecto (cualquier ubicación);
- refresca el PATH de la sesión tras `winget` (evita el bucle “Docker sigue sin estar en el PATH”);
- busca `docker.exe` también en Program Files y LocalAppData (instalación por usuario);
- comprueba WSL 2 (requisito de Docker Desktop) y puede abrir un PowerShell elevado con `wsl --install --no-distribution`; tras eso hay que **reiniciar Windows** y volver a ejecutar `iniciar.cmd`;
- no reinstala Docker si ya detecta Docker Desktop;
- inicia Docker Desktop y espera al motor;
- crea `.venv`, sincroniza Typer/Rich y abre la misma consola interactiva que en Linux.

No use `.\iniciar.ps1` a menos que ejecute PowerShell con Bypass; la vía soportada es `iniciar.cmd`. No hace falta activar el venv a mano.

Ambos lanzadores comprueban los servidores y las rutas `/salud` y `/docs`, registran diez respuestas de `/` y abren una consola de comandos. El lanzador usa un nombre de proyecto Compose derivado de la ruta del clon, distinto del proyecto manual, y al salir detiene únicamente esa pila. Si ya hay contenedores de esa misma pila, se niega a tomarlos o apagarlos; ciérralos manualmente antes de volver a iniciar.

### Consola interactiva

Al finalizar el arranque, escribe un comando y pulsa **Enter**:

| Comando | Acción |
|---|---|
| `ayuda` | Muestra los comandos disponibles. |
| `estado` | Consulta Docker y el `/salud` de cada API por separado, además del balanceador. |
| `detener 1` / `iniciar 1` | Detiene o recupera solo esa API. Puedes usar cualquier número válido en el modo 2 o 3. |
| `probar` | Hace diez solicitudes reales a `/`, mostrando servidor, duración y errores. Repite antes, durante y después de una caída. |
| `informe` | Guarda en `informes/` un Markdown con cronología y un CSV de solicitudes para el trabajo escrito. |
| `salir` o **Ctrl+C** | Detiene la pila propia y termina. |

Ejemplo para el informe: `estado` → `probar` → `detener 2` → `estado` → `probar` → `iniciar 2` → `estado` → `probar` → `informe`. El estado Docker y la respuesta HTTP pueden diferir; nunca se da por conectado un servidor solo porque el contenedor esté activo. Un error de petición se registra y no se reemplaza por una respuesta ficticia. Los informes se quedan en tu PC y están ignorados por Git.

URLs: [principal](http://localhost:8080/), [salud](http://localhost:8080/salud), [Swagger](http://localhost:8080/docs).

## Uso manual sin lanzador

```bash
docker compose -f compose.yaml up --build -d                   # dos servidores
docker compose -f compose.yaml down
docker compose --profile tres -f compose.yaml -f compose.tres.yaml up --build -d  # tres
docker compose --profile tres -f compose.yaml -f compose.tres.yaml down
```

No mezcles las fases sin detener la anterior: comparten puerto 8080. `docker compose logs` muestra información para depurar; el lanzador muestra el error de Docker si falla el arranque. Para ejecutar tests locales: `.venv/bin/python -m unittest discover -s tests -v` (Windows: `.venv\Scripts\python.exe -m unittest discover -s tests -v`). Windows no se ha probado en este equipo Linux.

## Archivos y relación con el taller

- `app.py`: FastAPI; `/` informa del servidor y `/salud` devuelve su estado. `SERVIDOR` distingue cada instancia.
- `Dockerfile`: `FROM python:3.11-slim` elige la base; `WORKDIR /app` fija el directorio; `COPY requirements.txt .` y `RUN pip install ...` instalan dependencias; `COPY app.py .` añade la aplicación; `EXPOSE 8000` documenta el puerto interno; `CMD ... uvicorn` inicia el servidor escuchando en todas las interfaces.
- `compose.yaml` y `nginx/nginx.conf`: fase inicial con dos servidores y Nginx en el puerto 80 interno, publicado como 8080.
- `compose.tres.yaml` y `nginx/nginx.tres.conf`: ampliación con `servidor3` y upstream de tres servidores.
- `launcher.py`, `interactive.py`, `iniciar.sh`, `iniciar.cmd`, `activar.cmd`, `scripts/windows/preparar.ps1`, `iniciar.ps1`, `requirements-cli.txt`: ejecución multiplataforma. En Windows la entrada es `iniciar.cmd`. `tests/` valida modos, estado, comandos, informes y limpieza.

**Autor original:** Yecid Villamil · Universidad de Cundinamarca, Ingeniería de Sistemas y Computación. [Repositorio del equipo](https://github.com/VILLAMIL-EST/-Contenedores-Docker). Documentación: [Docker](https://docs.docker.com/), [FastAPI](https://fastapi.tiangolo.com/), [Nginx](https://nginx.org/en/docs/).
