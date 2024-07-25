# Obtém a lista de trabalhos de impressão pendentes
$printJobs = Get-WmiObject -Query "SELECT * FROM Win32_PrintJob"
$total_jobs = $printJobs.Count

# Exibe o total de trabalhos pendentes
Write-Host "$total_jobs"
