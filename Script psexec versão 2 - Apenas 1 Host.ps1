# Script para Copiar Script Microsoft para uma maquina via psexec.
# Batch Criado Por: Everton Cardoso Deolinda
# Atualizado: 09/05/2024

# Pergunta qual HOST deseja aplicar
Write-Host "Digite o HOST:"
$nomeHost = Read-Host

# Pergunta qual a SENHA
Write-Host "Digite a SENHA:"
$senha = Read-Host -AsSecureString
$senhaBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($senha)
$senhaPlana = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($senhaBSTR)

# Exibe mensagem de início da adição de credenciais
Write-Host "Adicionando credenciais..."

# Executa o comando cmdkey.exe para adicionar as credenciais
cmdkey.exe /add:$nomeHost /user:$nomeHost\administrador /pass:$senhaPlana

# Exibe mensagem de conclusão da adição de credenciais
Write-Host "Credenciais adicionadas com sucesso."

# Exibe mensagem sobre o acesso à pasta Windows\System32
Write-Host "Acessando a pasta Windows\System32..."

# Comando para acessar a pasta Windows\System32
Set-Location -Path "C:\Windows\System32"

# Exibe mensagem sobre a criação da pasta "Script"
Write-Host "Verificando e criando a pasta 'Script'..."

# Comando para criar a pasta "Script" na raiz
psexec -u "$nomeHost\administrador" -p $senhaPlana \\$nomeHost -i cmd /c "mkdir C:\Script"

# Comando para verificar se a pasta "Script" existe
$scriptFolderExists = psexec -u "$nomeHost\administrador" -p $senhaPlana \\$nomeHost -i cmd /c "if exist C:\Script (echo 1) else (echo 0)"

# Se a pasta "Script" não existir, criá-la
if ($scriptFolderExists -eq "0") {
    # Comando para criar a pasta "Script" na raiz
    psexec -u "$nomeHost\administrador" -p $senhaPlana \\$nomeHost -i cmd /c "mkdir C:\Script"
    Write-Host "Pasta 'Script' criada."
} else {
    Write-Host "Pasta 'Script' já existe."
}

# Exibe mensagem sobre a cópia do arquivo "telnet"
Write-Host "Copiando o arquivo 'telnet' para o host remoto..."

# Obter o nome de usuário atual
$currentUsername = $env:USERNAME

# Copiar o arquivo "telnet" para a pasta Script no computador remoto
Copy-Item -Path "C:\Users\$currentUsername\Script\*" -Destination "\\$nomeHost\c$\Script"

# Exibe mensagem sobre a execução do arquivo "telnet"
Write-Host "Executando o arquivo 'telnet' no host remoto..."

# Comando para executar o psexec
psexec -u "$nomeHost\administrador" -p $senhaPlana \\$nomeHost -i cmd /c "\Script\teltecv2"

# Exibe mensagem sobre a pausa
Write-Host "Aguardando 30 segundos..."
Start-Sleep -Seconds 30
Write-Host "Script concluído."

