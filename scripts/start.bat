@echo off
setlocal

set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..

docker stop pm-app 2>nul
docker rm pm-app 2>nul

cd /d "%PROJECT_ROOT%"
docker build -t pm-app .
docker run -d --name pm-app -p 8000:8000 pm-app

echo App running at http://localhost:8000
