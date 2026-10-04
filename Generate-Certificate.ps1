# Create the certificate
$cert = New-SelfSignedCertificate -DnsName "CAPI Event52 Demo"

# Export the certificate as a file
Export-Certificate -Cert $cert -FilePath "Server.crt"
