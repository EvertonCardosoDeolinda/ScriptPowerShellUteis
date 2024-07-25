# Obter todas as impressoras instaladas no servidor
$impressoras = Get-Printer

# Contador para as impressoras em estado de erro
$impressoras_erro = 0

# Verificar o status de cada impressora
foreach ($impressora in $impressoras) {
    if ($impressora.PrinterStatus -eq "Error") {
        $impressoras_erro++
    }
}

# Exibir o número de impressoras em estado de erro
Write-Host "$impressoras_erro"
#Write-Host "Número de impressoras em estado de erro: $impressoras_erro"
