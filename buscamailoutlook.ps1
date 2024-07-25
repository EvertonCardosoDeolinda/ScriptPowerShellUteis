# Script para acessar o Exhange Outlook e buscar e-mail que contenham anexo .XML e XLSX.
# Batch Criado Por: Everton Cardoso Deolinda
# Atualizado: 08/05/2024

#Comando para gerar a senha do adm.edi caso seja alterada:
#Read-Host -Prompt "Digite sua senha" -AsSecureString | ConvertFrom-SecureString | Out-File "C:\xml\SenhaCriptografada.txt"

# Comando para obter a data atual
$currentDate = Get-Date -Format "yyyyMMdd"
# Caminho que é printado o log
$logFile = "C:\xml\log\log_busca_outlookweb_adm.edi.$currentDate.txt"

# Função para registrar mensagens de log
function Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    $logEntry | Out-File -Append -FilePath $logFile
}

# Configurações
$email = "adm.edi@angeloni.com.br"
$senhaCriptografada = Get-Content "C:\xml\SenhaCriptografada.txt" | ConvertTo-SecureString
$senha = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($senhaCriptografada))
$pastaDestino = "C:\xml\enviar"

# Função para fazer login no Outlook
function ConnectToOutlook {
    Log "Conectando ao Outlook..."
    $Outlook = New-Object -ComObject Outlook.Application
    $Namespace = $Outlook.GetNamespace("MAPI")
    $Namespace.Logon($null, $null, $false, $false)
    return $Namespace
}

# Função para baixar anexos XML e XLSX de e-mails
function DownloadAttachmentsFromEmail($email) {
    Log "Baixando anexos do e-mail..."
    $emailFolder = $Namespace.Folders.Item($email)
    $inboxFolder = $emailFolder.Folders.Item("Caixa de Entrada")
    $AnexoFolder = $inboxFolder.Folders.Item("Anexo")  # Ajuste aqui para acessar a pasta "Anexo"
    $processedFolder = $inboxFolder.Folders.Item("Processado")
    $attachments = @()

    foreach ($item in $AnexoFolder.Items) {
        if ($item.Attachments.Count -gt 0) {
            foreach ($attachment in $item.Attachments) {
                if ($attachment.FileName -like "*.xml" -or $attachment.FileName -like "*.xlsx") {
                    $attachment.SaveAsFile("$pastaDestino\$($attachment.FileName)")
                    $attachments += $attachment.FileName
                    Log "Anexo baixado: $($attachment.FileName)"
                }
            }
            # Esperar 30 segundos antes de mover o e-mail para a pasta "Processado"
            #Start-Sleep -Seconds 30
            $item.Move($processedFolder)
        }
    }

    return $attachments
}

# Inicialização do script
Log "Iniciando script..."

# Login no Outlook
$Namespace = ConnectToOutlook

# Baixar anexos XML e XLSX
$anexos = DownloadAttachmentsFromEmail $email

# Exibir anexos baixados
if ($anexos.Count -gt 0) {
    Log "Anexos baixados:"
    foreach ($anexo in $anexos) {
        Log $anexo
    }
} else {
    Log "Nenhum anexo encontrado."
}
