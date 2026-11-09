@echo off
setlocal EnableExtensions EnableDelayedExpansion
rem Entrada Windows recomendada: no depende de ExecutionPolicy de PowerShell.
rem Funciona desde cualquier ruta; siempre opera sobre la carpeta de este archivo.
cd /d "%~dp0" || exit /b 1

set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
title Practica servidores Docker
set "ROOT=%cd%"
set "VENV=%ROOT%\.venv"
set "VENV_PY=%VENV%\Scripts\python.exe"
set "REQ=%ROOT%\requirements-cli.txt"
set "LAUNCHER=%ROOT%\launcher.py"

call :ensure_python
if errorlevel 1 goto :fail
call :ensure_docker
if errorlevel 1 goto :fail
call :ensure_venv
if errorlevel 1 goto :fail

echo.
echo Arrancando la practica (misma consola interactiva que en Linux)...
echo Carpeta del proyecto: %ROOT%
echo.
"%VENV_PY%" "%LAUNCHER%" %*
set "CODE=%ERRORLEVEL%"
if not "%CODE%"=="0" goto :fail
exit /b 0

:ensure_python
where py >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%I in ('py -3 -c "import sys; print(sys.executable)" 2^>nul') do set "SYS_PY=%%I"
)
if not defined SYS_PY (
    where python >nul 2>&1
    if not errorlevel 1 (
        for /f "delims=" %%I in ('python -c "import sys; print(sys.executable)" 2^>nul') do set "SYS_PY=%%I"
    )
)
if defined SYS_PY (
    "%SYS_PY%" -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)" >nul 2>&1
    if not errorlevel 1 exit /b 0
    echo [!] Python encontrado, pero se necesita 3.11 o superior.
) else (
    echo [!] No se encontro Python 3.11+ en el PATH.
)

call :ask_install "Instalar Python 3.12 con winget ahora" "Python.Python.3.12"
if errorlevel 1 (
    echo     Instale Python 3.11+ desde https://www.python.org/downloads/
    echo     Marque "Add python.exe to PATH" e intente de nuevo: activar.cmd
    exit /b 1
)
set "SYS_PY="
where py >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%I in ('py -3 -c "import sys; print(sys.executable)" 2^>nul') do set "SYS_PY=%%I"
)
if not defined SYS_PY (
    where python >nul 2>&1
    if not errorlevel 1 (
        for /f "delims=" %%I in ('python -c "import sys; print(sys.executable)" 2^>nul') do set "SYS_PY=%%I"
    )
)
if not defined SYS_PY (
    echo [!] Python sigue sin estar disponible. Cierre y abra una terminal nueva tras instalarlo.
    exit /b 1
)
"%SYS_PY%" -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)" >nul 2>&1
if errorlevel 1 (
    echo [!] La version instalada sigue siendo inferior a 3.11.
    exit /b 1
)
exit /b 0

:ensure_docker
where docker >nul 2>&1
if errorlevel 1 (
    echo [!] No se encontro Docker en el PATH.
    call :ask_install "Instalar Docker Desktop con winget ahora" "Docker.DockerDesktop"
    if errorlevel 1 (
        echo     Instale Docker Desktop, reinicie si lo pide y confirme que el motor esta en marcha.
        echo     Guia: https://docs.docker.com/desktop/setup/install/windows-install/
        exit /b 1
    )
    where docker >nul 2>&1
    if errorlevel 1 (
        echo [!] Docker sigue sin estar en el PATH. Reinicie la sesion o el equipo tras instalar Docker Desktop.
        exit /b 1
    )
)
docker compose version >nul 2>&1
if errorlevel 1 (
    echo [!] Docker esta presente, pero "docker compose" no responde.
    echo     Abra Docker Desktop y espere a "Engine running", luego vuelva a ejecutar activar.cmd.
    exit /b 1
)
docker info >nul 2>&1
if errorlevel 1 (
    echo [!] Docker no responde (motor detenido o sin permisos).
    echo     Inicie Docker Desktop y reintente cuando el icono indique que el motor esta activo.
    exit /b 1
)
exit /b 0

:ensure_venv
if not exist "%VENV_PY%" (
    echo Creando entorno local .venv en %VENV% ...
    "%SYS_PY%" -m venv "%VENV%"
    if errorlevel 1 (
        echo [!] No se pudo crear el entorno virtual.
        exit /b 1
    )
)
if not exist "%REQ%" (
    echo [!] Falta requirements-cli.txt en %ROOT%
    exit /b 1
)
if not exist "%LAUNCHER%" (
    echo [!] Falta launcher.py en %ROOT%
    exit /b 1
)
echo Instalando dependencias del lanzador (Typer/Rich) en .venv ...
"%VENV_PY%" -m pip install -q -r "%REQ%"
if errorlevel 1 (
    echo [!] No se pudieron instalar las dependencias del lanzador.
    exit /b 1
)
if not exist "%ROOT%\informes" mkdir "%ROOT%\informes" >nul 2>&1
exit /b 0

:ask_install
set "PROMPT_TEXT=%~1"
set "WINGET_ID=%~2"
where winget >nul 2>&1
if errorlevel 1 (
    echo     winget no esta disponible; no se puede instalar automaticamente.
    exit /b 1
)
set /p "ANSWER=%PROMPT_TEXT%? [S/N]: "
if /I not "%ANSWER%"=="S" if /I not "%ANSWER%"=="Y" if /I not "%ANSWER%"=="SI" exit /b 1
echo Instalando %WINGET_ID% (puede pedir confirmacion de Windows)...
winget install -e --id "%WINGET_ID%" --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
    echo [!] winget no pudo completar la instalacion de %WINGET_ID%.
    exit /b 1
)
exit /b 0

:fail
echo.
echo La practica no se inicio. Revise los mensajes anteriores.
echo Uso: activar.cmd --servidores 2
echo      activar.cmd --servidores 3
echo.
pause
exit /b 1
