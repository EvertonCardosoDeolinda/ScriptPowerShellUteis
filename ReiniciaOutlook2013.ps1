# Script para Reiniciado Outlook, gpupdate /force e iniciar..
# Batch Criado Por: Everton Cardoso Deolinda
# Atualizado: 28/05/2024

# Encerra todos os processos do Outlook 2013
Get-Process -Name OUTLOOK -ErrorAction SilentlyContinue | ForEach-Object {
    $_.CloseMainWindow()
    $_.WaitForExit(5000)
    if (-not $_.HasExited) {
        $_ | Stop-Process -Force
    }
}

# Executa o gpupdate /force
Invoke-Expression -Command "gpupdate /force"

# Inicia o Outlook novamente
#Start-Process -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\OUTLOOK.EXE"
Start-Process -FilePat "C:\Program Files\Microsoft Office 15\root\office15\OUTLOOK.EXE"

