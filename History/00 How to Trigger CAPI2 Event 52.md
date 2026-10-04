# How to Trigger CAPI2 Event 52

## Prompt for AI

I want to simulate the behavior of a third-party server application.

I installed the server on my own machine. The server can be accessed via HTTPS.
It was installed with a self-signed certificate.

I wrote a client application with C# to access the server.
The client runs on the same machine with the server.

When the client accesses the server, a CAPI2 log of Event ID 52 is triggered
(CAPI2 is enabled in advance). The log shows that access to ctldl.windowsupdate.com is triggered.

Now I want to simulate the behavior without using the third-party server application in two ways.

1. Use PowerShell or Command Prompt to generate a self-signed certificate and verify it.
2. Write a sample HTTPS server with C# and access the sample server.

Please show me the detail steps to implement the two ways.

## The Answer

Here is [my chat history with Gemini](https://share.gemini.google/wm2b2HTNy86L)

As a correction, the step of *Clear the CAPI Network Cache* should be replaced with deleting the
`EncodedCtl` and `LastSyncTime` keys in the following Windows registry.

```plain
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemCertificates\AuthRoot\AutoUpdate
```

Also, the certificate does not need to be added to the store when created.