using System.Net.Security;
using System.Security.Authentication;

using var handler = new HttpClientHandler
{
    SslProtocols = SslProtocols.Tls12,
    ServerCertificateCustomValidationCallback = (request, _, _, sslErrors) => true
};

using var client = new HttpClient(handler);
using var response = await client.GetAsync("https://localhost:8443/");
response.EnsureSuccessStatusCode();

Console.WriteLine(await response.Content.ReadAsStringAsync());
