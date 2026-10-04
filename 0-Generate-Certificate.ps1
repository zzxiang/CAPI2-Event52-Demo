# Create the certificate
$cert = New-SelfSignedCertificate -DnsName "CAPI2 Event52 Demo"

# Export the certificate as a file
Export-Certificate -Cert $cert -FilePath "CAPI2 Event52 Demo.crt"

# Export the PFX for the server
$pwd = ConvertTo-SecureString -String "password123" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath "CAPI2 Event52 Demo.pfx" -Password $pwd
