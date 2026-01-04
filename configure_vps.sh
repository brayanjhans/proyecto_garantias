#!/bin/bash
# Script para configurar variables de entorno del frontend

echo "===========================================" 
echo "Configurando Frontend en VPS..."
echo "==========================================="

# Navegar al directorio del frontend
cd /home/mcqsjcqdb/htdocs/mcqs-jcq.com || { echo "Error: No se puede acceder al directorio del frontend"; exit 1; }

# Crear archivo .env.local con la URL del backend
echo "NEXT_PUBLIC_API_URL=https://back.mcqs-jcq.cloud" > .env.local

echo "✓ Variable de entorno configurada:"
cat .env.local
echo ""

# Verificar estado de servicios PM2
echo "==========================================="
echo "Estado de servicios PM2:"
echo "==========================================="
pm2 list

echo ""
echo "==========================================="
echo "Logs recientes del backend:"
echo "==========================================="
pm2 logs backend --lines 10 --nostream

echo ""
echo "==========================================="
echo "Configuración completada"
echo "==========================================="
