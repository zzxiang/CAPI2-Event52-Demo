# Create a self-signed certificate (for testing/local development)
# Need to run PowerShell as Administrator
$cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "Cert:\LocalMachine\My"
$thumbprint = $cert.Thumbprint

# Bind the certificate to port 8443 using netsh
# Generate an arbitrary GUID for the application ID and bind the thumbprint
$appId = "{" + [Guid]::NewGuid().ToString() + "}"
netsh http add sslcert ipport=0.0.0.0:8443 certhash=$thumbprint appid=$appId

# Create the HttpListener instance
$listener = New-Object System.Net.HttpListener

# Define HTTPS prefix (Note the "https://" protocol)
$listener.Prefixes.Add("https://localhost:8443/")

try {
    $listener.Start()
    Write-Host "HTTPS Server running at https://localhost:8443/" -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop." -ForegroundColor Yellow

    while ($listener.IsListening) {
        # Block until a client connects
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        Write-Host "[$($request.HttpMethod)] Request received from $($request.RemoteEndPoint)"

        # Prepare HTML response content
        $responseString = "<html><body><h1>Hello from PowerShell HTTPS Server!</h1></body></html>"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseString)

        # Set headers
        $response.ContentLength64 = $buffer.Length
        $response.ContentType = "text/html"

        # Send response
        $output = $response.OutputStream
        $output.Write($buffer, 0, $buffer.Length)
        $output.Close()
    }
}
finally {
    $listener.Stop()
    $listener.Close()
}
