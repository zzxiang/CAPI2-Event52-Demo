# CAPI2 Event52 Demo

This demo shows how to trigger a CAPI2 "Retrieve Object from Network" (Event ID 52 and
the following 53) log on Windows.

## Enviornment

The scripts in this repository were tested in the following environment:

- Windows 11 Pro 26H2
- PowerShell 5.1
- .NET 10.0

The Windows version was checked with the following PowerShell command:

```PowerShell
Get-ComputerInfo | Select-Object OsName, OSDisplayVersion, OsHardwareAbstractionLayer
```

The PowerShell version was checked with the following PowerShell command:

```PowerShell
$PSVersionTable
```

The .NET version was checked with the following PowerShell command.

```PowerShell
dotnet --version
```

## How to Use the Scripts

Run the # server with [Launch-Server.ps1](Launch-Server.ps1).

Run the .NET 10 client with `dotnet run --project .\Client\Client.csproj`, or the
.NET Framework 4.8 client with `dotnet run --project .\Client48\Client48.csproj`.

## Check the Outbound Rules of Windoes Firewall

1. Press `Windows Key + R`, type `wf.msc`, and press **Enter** to open Windows Defender Firewall with Advanced Security.
2. Click on **Outbound Rules** in the left-hand column to view all active rules.
