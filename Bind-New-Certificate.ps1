# Create a self-signed certificate (for testing/local development)
# Need to run PowerShell as Administrator
$cert = New-SelfSignedCertificate -DnsName "localhost.CAPI2.Event52.Demo"
$thumbprint = $cert.Thumbprint
Write-Host "Created a self-signed certificate"

# Bind the certificate to port 8443 using netsh
# Generate an arbitrary GUID for the application ID and bind the thumbprint
$appId = "{" + [Guid]::NewGuid().ToString() + "}"
netsh http add sslcert ipport=0.0.0.0:8443 certhash=$thumbprint appid=$appId
Write-Host "Bound the certificate to port 8443"
