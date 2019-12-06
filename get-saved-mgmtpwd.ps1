$ErrorActionPreference = 'Stop'

$mgmtCredFile = "$($env:APPDATA)\mgmtCreds.xml"
if (-not (Test-Path $mgmtCredFile)) {
    throw "Could not find '$mgmtCredFile'"
}

$mgmtCreds = Import-Clixml $mgmtCredFile
if (-not $mgmtCreds) {
    throw "Unable to import MGMT creds from '$mgmtCredFile'"
}

$mgmtCreds.GetNetworkCredential().Password | Set-Clipboard
Write-Host "Copied MGMT password to clipboard"