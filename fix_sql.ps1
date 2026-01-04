# Script para agregar DROP TABLE IF EXISTS a cada CREATE TABLE
$sourceFile = "C:\Users\Brayan\Downloads\mcqsjcqdb.sql"
$outputFile = "C:\Users\Brayan\Downloads\mcqsjcqdb_final.sql"

Write-Host "Preparando archivo SQL con DROP TABLE..." -ForegroundColor Cyan

# Leer contenido
$content = Get-Content $sourceFile -Raw

# Agregar USE DATABASE al inicio
$newContent = "USE mcqsjcqdb;`n`n"

# Agregar DROP TABLE IF EXISTS antes de cada CREATE TABLE
$newContent += $content -replace "CREATE TABLE ``([^``]+)``", "DROP TABLE IF EXISTS ```$1```;`nCREATE TABLE ```$1```"

# Guardar archivo corregido
$newContent | Set-Content $outputFile -Encoding UTF8

Write-Host "Archivo final creado: mcqsjcqdb_final.sql" -ForegroundColor Green
Write-Host "Este archivo:" -ForegroundColor Yellow
Write-Host "  - Incluye: USE mcqsjcqdb;" -ForegroundColor Yellow
Write-Host "  - Elimina tablas existentes antes de crearlas" -ForegroundColor Yellow
Write-Host "`nAhora importa: C:\Users\Brayan\Downloads\mcqsjcqdb_final.sql" -ForegroundColor Cyan
