using System.Net.Security;
using System.Security.Authentication;
using System.Diagnostics;

using var handler = new HttpClientHandler
{
    ServerCertificateCustomValidationCallback = (request, _, _, sslErrors) => true,
};

using var client = new HttpClient(handler)
{
    Timeout = TimeSpan.FromSeconds(5),
};
var stopwatch = Stopwatch.StartNew();
Console.WriteLine($"Client sending request at {DateTimeOffset.Now:O}");

try
{
    using var response = await client.GetAsync("https://localhost:8443/");
    Console.WriteLine($"Client received response at {DateTimeOffset.Now:O}");
    response.EnsureSuccessStatusCode();

    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
catch (Exception exception)
{
    Console.WriteLine($"Client received exception at {DateTimeOffset.Now:O}: {exception.GetType().Name}: {exception.Message}");
}
finally
{
    stopwatch.Stop();
    Console.WriteLine($"Client elapsed time: {stopwatch.Elapsed.TotalMilliseconds:F2} ms");
}
