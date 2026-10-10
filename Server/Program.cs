using System.Net;
using System.Text;

using var listener = new HttpListener();
listener.Prefixes.Add("https://localhost:8443/");

using var cancellation = new CancellationTokenSource();
ConsoleCancelEventHandler cancelHandler = (_, eventArgs) =>
{
    eventArgs.Cancel = true;
    cancellation.Cancel();
    listener.Close();
};

Console.CancelKeyPress += cancelHandler;

try
{
    listener.Start();
    Console.WriteLine("HTTPS Server running at https://localhost:8443/");
    Console.WriteLine("Press Ctrl+C to stop.");

    while (!cancellation.IsCancellationRequested)
    {
        HttpListenerContext context;
        try
        {
            context = listener.GetContext();
        }
        catch (HttpListenerException) when (cancellation.IsCancellationRequested)
        {
            break;
        }
        catch (ObjectDisposedException) when (cancellation.IsCancellationRequested)
        {
            break;
        }

        var request = context.Request;
        var response = context.Response;

        Console.WriteLine($"[{request.HttpMethod}] Request received from {request.RemoteEndPoint}");

        var body = "<html><body><h1>Hello from C# HTTPS Server!</h1></body></html>";
        var buffer = Encoding.UTF8.GetBytes(body);
        response.ContentLength64 = buffer.Length;
        response.ContentType = "text/html";

        try
        {
            response.OutputStream.Write(buffer);
        }
        finally
        {
            response.Close();
        }
    }
}
finally
{
    Console.CancelKeyPress -= cancelHandler;
    listener.Close();
}
