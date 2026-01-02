$password = "mcqs-jcq-front"
$sshUser = "mcqs-jcq-front"
$sshHost = "72.61.219.79"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "INICIANDO DESPLIEGUE AUTOMATIZADO AL VPS (RECOVERY - FINAL)" -ForegroundColor Green
Write-Host "Usuario: $sshUser | Puerto App: 3003" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Función para ejecutar comando SSH
function Run-SSHCommand {
    param($command, $description)
    Write-Host "► $description..." -ForegroundColor Yellow
    $result = echo $password | ssh -o StrictHostKeyChecking=no "$sshUser@$sshHost" $command 2>&1
    Write-Host $result
    Write-Host ""
}

# PASO 0: Clonar Repo (Si no existe)
Run-SSHCommand "if [ ! -d /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud/.git ]; then git clone https://github.com/brayanjhans/proyecto_garantias.git /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud; fi" "Verificando/Clonando repositorio"

# PASO 1: Git Pull
Run-SSHCommand "cd /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud && git pull origin main" "Actualizando código desde GitHub"

# PASO 2: .env.production (Frontend apunta a back.mcqs-jcq.cloud)
Run-SSHCommand "echo 'NEXT_PUBLIC_API_URL=https://back.mcqs-jcq.cloud' > /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud/frontend/.env.production" "Creando archivo .env.production"

# PASO 3: NPM Install
Run-SSHCommand "cd /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud/frontend && npm install" "Instalando dependencias NPM"

# PASO 4: NPM Build
Write-Host "► Reconstruyendo Frontend (puede tardar 1-2 minutos)..." -ForegroundColor Yellow
$buildResult = echo $password | ssh -o StrictHostKeyChecking=no "$sshUser@$sshHost" "cd /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud/frontend && rm -rf .next && npm run build" 2>&1
Write-Host $buildResult
Write-Host ""

# PASO 5: Iniciar Backend (Puerto 8000)
# CloudPanel "back.mcqs-jcq.cloud" (reverse proxy) leerá http://127.0.0.1:8000
Run-SSHCommand "pm2 delete fastapi-mcqs 2>/dev/null; cd /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud && pip install -r requirements.txt && pm2 start 'venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000' --name fastapi-mcqs --interpreter python3" "Iniciando/Reiniciando Backend"

# PASO 6: Iniciar Frontend (Puerto 3003)
# OJO: Pasamos -p 3003 explícitamente porque CloudPanel configuró ese puerto.
Run-SSHCommand "pm2 delete nextjs-mcqs 2>/dev/null; cd /home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud/frontend && pm2 start 'npm start -- -p 3003' --name nextjs-mcqs" "Iniciando/Reiniciando Frontend (Puerto 3003)"

# PASO 7: Guardar PM2
Run-SSHCommand "pm2 save" "Guardando configuración PM2"

# PASO 8: Status
Run-SSHCommand "pm2 status" "Verificando estado de servicios"

Write-Host "==================================================" -ForegroundColor Green
Write-Host "✅ DESPLIEGUE FINAL COMPLETADO" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Abre tu navegador en: https://mcqs-jcq.cloud" -ForegroundColor Cyan
