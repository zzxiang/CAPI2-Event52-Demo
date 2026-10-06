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
