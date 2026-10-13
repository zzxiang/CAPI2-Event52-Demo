# A Demo Related-to CAPI2 Event ID 52

This repository was created to reproduce and investigate a strange system behavior described below.
It shows how to trigger a CAPI2 "Retrieve Object from Network" (Event ID 52 and the following 53)
log on Windows.

## A Strange Behavior of Our System

When our team deployed a server/client system to a new production enviornment,
we observed a strange behavior: the HTTPS request sent from the client to the server often timeout,
even the two machines are in the same LAN and the PING replies in 1ms.

### A Brief Explanation of the Reason

## The Environment This Repository Ran On

It is also the environment of my personal Windows computer:

- Windows 11 Pro 26H2
- PowerShell 5.1
- .NET 10.0, except that [Client48](Client48/) targets .NET Framework 4.8

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

## Steps to Reproduce the Behavior

Run the # server with [Launch-Server.ps1](Launch-Server.ps1).

Run the .NET 10 client with [Launch-Client.ps1](Launch-Client.ps1),
or the .NET Framework 4.8 client with [Launch-Client48.ps1](Launch-Client48.ps1).

## Check the Outbound Rules of Windoes Firewall

1. Press `Windows Key + R`, type `wf.msc`,
   and press **Enter** to open Windows Defender Firewall with Advanced Security.
2. Click on **Outbound Rules** in the left-hand column to view all active rules.

## The Group Policy related to Certificate Retrieval

### Turn off Automatic Root Certificates Update

Group Policy path

```plain
Computer Configuration →
Administrative Templates →
System →
Internet Communication Management →
Internet Communication Settings
```

Policy: Turn off Automatic Root Certificates Update

Set to Enabled to disable automatic root-certificate updates.
This stops that particular update mechanism,
but does not disable all chain-building network retrieval.

### Allow issuer certificate (AIA) retrieval during path validation

Group Policy path

```plain
Computer Configuration →
Windows Settings →
Security Settings →
Public Key Policies →
Certificate Path Validation Settings →
Network Retrieval
```

This is a checkbox rather than a standalone On/Off policy.
Select Define these policy settings,
then clear Allow issuer certificate (AIA) retrieval during path validation
to prevent downloading missing intermediate certificates through AIA.

## Another Strange Behavior: the Actual Timeout Duration is Longer Than We Set

It was because our client targeted .NET Framework 4.8. In this repository,
I created another client targeting .NET Framework 4.8 to reproduce this behavior,
and enabled network tracing for the client to invesitgate the behavior.

The .NET Framework 4.8 client enables verbose network tracing.
It writes its network trace to `network.log` in the same directory of `Client48.exe`.
