# Script para transferir base de datos al VPS
$dbFile = "C:\Users\Brayan\Downloads\mcqsjcqdb.sql"
$remoteUser = "michaelmcqs7@gmail.com"
$remoteHost = "72.61.219.79"
$remotePath = "/home/michaelmcqs7/mcqsjcqdb.sql"
$password = "Juegos-12345#"

# Usar scp con password
$env:SSHPASS = $password
& scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$dbFile" "${remoteUser}@${remoteHost}:${remotePath}"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Archivo transferido exitosamente"
    
    # Ahora importar la base de datos
    Write-Host "🔄 Importando base de datos..."
    $importCmd = "mysql -u mcqsjcqdb_user -p'mcqs-jcq-db' mcqsjcqdb < /home/michaelmcqs7/mcqsjcqdb.sql"
    echo $password | ssh -o StrictHostKeyChecking=no "${remoteUser}@${remoteHost}" $importCmd
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Base de datos importada exitosamente"
    } else {
        Write-Host "❌ Error al importar base de datos"
    }
} else {
    Write-Host "❌ Error al transferir archivo"
}
