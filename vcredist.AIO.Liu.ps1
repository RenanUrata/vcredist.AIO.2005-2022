# Obtém o diretório atual do script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -Path $scriptDir

# Verifica se o script está sendo executado como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Executando como administrador..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $($MyInvocation.MyCommand.Path)" -Verb RunAs
    Exit
}

# Obtém todos os arquivos com "vcredist" no meio do nome
$files = Get-ChildItem -Filter "*vcredist*"

foreach ($file in $files) {
    # Verifica se o arquivo contém "2008" ou "2005" no nome
    if ($file.Name -like "*2008*" -or $file.Name -like "*2005*") {
        Write-Host "Instalando $($file.Name) com /q ..."
        Start-Process -FilePath $file.FullName -ArgumentList "/q" -Wait
    }
    else {
        Write-Host "Instalando $($file.Name) com /quiet ..."
        Start-Process -FilePath $file.FullName -ArgumentList "/quiet" -Wait
    }
    Write-Host "Instalação concluída para $($file.Name)."
}

Write-Host "Todos os arquivos foram instalados com sucesso!"
