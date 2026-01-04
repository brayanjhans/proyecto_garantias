# Script para dividir archivo SQL en partes menores a 8MB
$sourceFile = "C:\Users\Brayan\Downloads\mcqsjcqdb.sql"
$outputDir = "C:\Users\Brayan\Downloads\sql_parts"
$maxSizeBytes = 7 * 1024 * 1024  # 7MB para estar seguros

# Crear directorio de salida
if (Test-Path $outputDir) {
    Remove-Item $outputDir -Recurse -Force
}
New-Item -ItemType Directory -Path $outputDir | Out-Null

Write-Host "Dividiendo archivo SQL en partes de ~7MB..." -ForegroundColor Cyan

# Leer el archivo completo
$content = Get-Content $sourceFile -Raw

# Dividir por statements SQL (buscando punto y coma seguido de salto de línea)
$statements = $content -split ";\r?\n"

$partNumber = 1
$currentSize = 0
$currentPart = @()

foreach ($statement in $statements) {
    $statementSize = [System.Text.Encoding]::UTF8.GetByteCount($statement + ";`n")
    
    # Si agregar este statement excede el limite, guardar la parte actual
    if (($currentSize + $statementSize) -gt $maxSizeBytes -and $currentPart.Count -gt 0) {
        $partFile = Join-Path $outputDir "part_$($partNumber.ToString('00')).sql"
        ($currentPart -join ";`n") + ";" | Out-File -FilePath $partFile -Encoding UTF8
        Write-Host "Creado: part_$($partNumber.ToString('00')).sql ($('{0:N2}' -f ($currentSize/1MB)) MB)" -ForegroundColor Green
        
        $partNumber++
        $currentPart = @()
        $currentSize = 0
    }
    
    # Agregar statement a la parte actual
    if ($statement.Trim().Length -gt 0) {
        $currentPart += $statement
        $currentSize += $statementSize
    }
}

# Guardar la ultima parte
if ($currentPart.Count -gt 0) {
    $partFile = Join-Path $outputDir "part_$($partNumber.ToString('00')).sql"
    ($currentPart -join ";`n") + ";" | Out-File -FilePath $partFile -Encoding UTF8
    Write-Host "Creado: part_$($partNumber.ToString('00')).sql ($('{0:N2}' -f ($currentSize/1MB)) MB)" -ForegroundColor Green
}

Write-Host "`nProceso completado!" -ForegroundColor Green
Write-Host "Archivos creados en: $outputDir" -ForegroundColor Yellow
Write-Host "Total de partes: $partNumber" -ForegroundColor Yellow
Write-Host "`nInstrucciones:" -ForegroundColor Cyan
Write-Host "1. Ve a phpMyAdmin del VPS"
Write-Host "2. Selecciona la base de datos mcqsjcqdb"
Write-Host "3. Ve a la pestana Importar"
Write-Host "4. Importa los archivos EN ORDEN: part_01.sql, part_02.sql, etc."
