# Obter todas as impressoras instaladas no servidor
$impressoras = Get-Printer

# Contador para as impressoras em estado offline
$impressoras_offline = 0

# Verificar o status de cada impressora
foreach ($impressora in $impressoras) {
    if ($impressora.PrinterStatus -eq "Offline") {
        $impressoras_offline++
    }
}

# Exibir o número de impressoras em estado offline
Write-Host "$impressoras_offline"

