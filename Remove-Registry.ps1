# Remove AuthRoot auto-update state to force a fresh network request during the validation
$registryPath = 'HKLM:\SOFTWARE\Microsoft\SystemCertificates\AuthRoot\AutoUpdate'
if (Test-Path -LiteralPath $registryPath) {
    $registryValues = Get-ItemProperty -LiteralPath $registryPath -ErrorAction Stop
    foreach ($valueName in 'EncodedCtl', 'LastSyncTime') {
        if ($registryValues.PSObject.Properties.Name -contains $valueName) {
            Remove-ItemProperty -LiteralPath $registryPath -Name $valueName -ErrorAction Stop
        }
    }
}
