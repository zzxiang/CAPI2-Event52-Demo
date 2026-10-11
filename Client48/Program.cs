using System;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;

internal static class Program
{
    private static async Task Main()
    {
        using (var handler = new HttpClientHandler
        {
            ServerCertificateCustomValidationCallback = (request, certificate, chain, sslErrors) => true,
        })
        using (var client = new HttpClient(handler)
        {
            Timeout = TimeSpan.FromSeconds(5),
        })
        {
            var stopwatch = Stopwatch.StartNew();
            Console.WriteLine("Client sending request at {0:O}", DateTimeOffset.Now);

            try
            {
                using (var response = await client.GetAsync("https://localhost:8443/"))
                {
                    Console.WriteLine("Client received response at {0:O}", DateTimeOffset.Now);
                    response.EnsureSuccessStatusCode();

                    Console.WriteLine(await response.Content.ReadAsStringAsync());
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine(
                    "Client received exception at {0:O}: {1}: {2}",
                    DateTimeOffset.Now,
                    exception.GetType().Name,
                    exception.Message);
            }
            finally
            {
                stopwatch.Stop();
                Console.WriteLine("Client elapsed time: {0:F2} ms", stopwatch.Elapsed.TotalMilliseconds);
            }
        }
    }
}
