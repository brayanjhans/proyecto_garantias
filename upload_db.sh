#!/bin/bash
# Script para importar base de datos en VPS

# Transferir archivo usando SFTP
echo "📤 Transfiriendo archivo de base de datos..."
sshpass -p "Juegos-12345#" scp -o StrictHostKeyChecking=no \
  "C:\Users\Brayan\Downloads\mcqsjcqdb.sql" \
  michaelmcqs7@gmail.com@72.61.219.79:/home/michaelmcqs7/mcqsjcqdb.sql

if [ $? -eq 0 ]; then
    echo "✅ Archivo transferido exitosamente"
    
    # Importar base de datos
    echo "🔄 Importando base de datos..."
    sshpass -p "Juegos-12345#" ssh -o StrictHostKeyChecking=no \
      michaelmcqs7@gmail.com@72.61.219.79 \
      "mysql -u mcqsjcqdb_user -p'mcqs-jcq-db' mcqsjcqdb < /home/michaelmcqs7/mcqsjcqdb.sql"
    
    if [ $? -eq 0 ]; then
        echo "✅ Base de datos importada exitosamente"
        
        # Limpiar archivo temporal
        sshpass -p "Juegos-12345#" ssh -o StrictHostKeyChecking=no \
          michaelmcqs7@gmail.com@72.61.219.79 \
          "rm /home/michaelmcqs7/mcqsjcqdb.sql"
        echo "🧹 Archivo temporal eliminado"
    else
        echo "❌ Error al importar base de datos"
        exit 1
    fi
else
    echo "❌ Error al transferir archivo"
    exit 1
fi
