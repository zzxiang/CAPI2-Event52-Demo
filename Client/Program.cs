using System.Net.Security;
using System.Security.Authentication;
using System.Diagnostics;

using var handler = new HttpClientHandler
{
    SslProtocols = SslProtocols.Tls12,
    ServerCertificateCustomValidationCallback = (request, _, _, sslErrors) => true
};

using var client = new HttpClient(handler);
var stopwatch = Stopwatch.StartNew();
using var response = await client.GetAsync("https://localhost:8443/");
stopwatch.Stop();
response.EnsureSuccessStatusCode();

Console.WriteLine(await response.Content.ReadAsStringAsync());
Console.WriteLine($"Server response time: {stopwatch.Elapsed.TotalMilliseconds:F2} ms");
