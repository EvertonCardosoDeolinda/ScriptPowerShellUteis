# Script para instalar Teams copiando de uma unidade e executando um comando do pacote
# Batch Criado Por: Everton Cardoso Deolinda
# Atualizado: 18/06/2024

# Define o caminho da unidade de rede e o diretório
$networkPath = "\\nas01a.angeloni.com.br\setores2\FS_aplic\Diversos\Teams"
$driveLetter = "O:"

# Desmonta a unidade de rede se já estiver mapeada
net use $driveLetter /delete /yes

# Monta a unidade de rede usando a autenticação integrada do Windows
net use $driveLetter $networkPath /persistent:yes

# Verifica se a montagem foi bem-sucedida
if (Test-Path -Path "$driveLetter\") {
    # Muda para o diretório especificado
    Set-Location -Path "$driveLetter\"
    
    # Define o caminho completo do pacote
    $packagePath = Join-Path -Path "$driveLetter\" -ChildPath "NewMicrosoftTeamsx64bits.msix"
    
    # Verifica se o pacote existe
    if (Test-Path -Path $packagePath) {
        try {
            # Executa o comando Add-AppPackage
            Add-AppPackage -Path $packagePath
            Write-Host "Pacote instalado com sucesso."
        } catch {
            Write-Error "Ocorreu um erro ao tentar instalar o pacote: $_"
            exit 1
        }
    } else {
        Write-Error "Pacote não encontrado no caminho especificado: $packagePath"
        exit 1
    }
} else {
    Write-Error "Falha ao montar a unidade de rede: $networkPath"
    exit 1
}

exit 0
