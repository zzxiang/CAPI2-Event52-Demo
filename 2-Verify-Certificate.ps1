$logName = 'Microsoft-Windows-CAPI2/Operational'
$wevtutilPath = Join-Path $env:SystemRoot 'System32\wevtutil.exe'
# Remember the current setting so this script can leave the log as it found it.
$previouslyEnabled = (Get-WinEvent -ListLog $logName -ErrorAction Stop).IsEnabled
$previousEnabledValue = if ($previouslyEnabled) { 'true' } else { 'false' }

try {
    # Enable CAPI2 logging for the certificate verification below.
    & $wevtutilPath sl $logName '/e:true'
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to enable the '$logName' event log. Run this script as an administrator."
    }

    if (-not (Get-WinEvent -ListLog $logName -ErrorAction Stop).IsEnabled) {
        throw "The '$logName' event log did not become enabled."
    }

    # This is the only command that actually performs the verification.
    certutil -verify "CAPI2 Event52 Demo.crt"

    # Show relevant events recorded during the 20 seconds immediately before this query.
    $startTime = (Get-Date).AddSeconds(-20)
    # Event 20 completes retrieval of a third-party root certificate from the network.
    # Events 52 and 53 mark the start and completion of retrieving an object from the network.
    $eventIds = 20, 52, 53
    try {
        Get-WinEvent -FilterHashtable @{ LogName = $logName; StartTime = $startTime; Id = $eventIds } -ErrorAction Stop |
            Format-List TimeCreated, Id, LevelDisplayName, Message
    }
    catch {
        if ($_.FullyQualifiedErrorId -like 'NoMatchingEventsFound*') {
            Write-Host "No CAPI2 events with IDs 20, 52, or 53 were recorded in the last 20 seconds."
        }
        else {
            throw
        }
    }
}

finally {
    # Restore the original setting even if verification or event retrieval fails.
    & $wevtutilPath sl $logName "/e:$previousEnabledValue"
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to restore the '$logName' event log to its previous state. Run this script as an administrator."
    }

    # Confirm the requested restoration took effect.
    if ((Get-WinEvent -ListLog $logName -ErrorAction Stop).IsEnabled -ne $previouslyEnabled) {
        throw "The '$logName' event log did not return to its previous state."
    }
}