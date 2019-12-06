param(
    [string] $domainTarget,
    [string] $inputFile
)
$ErrorActionPreference = 'Stop'

if ((-not $domainTarget) -and (-not $inputFile)) {
    Write-Error "Enter either a domain target (FQDN or IP address) or the path to a file containing a list of domain targets"
    return
}

$domainTargets = @()
if ($inputFile) {
    if (-not (Test-Path $inputFile)) {
        throw "Could not find '$inputFile'"
    }else {
        $domainTargets = Get-Content -Path $inputFile
    }
}

if ($domainTarget) {
    $domainTargets += $domainTarget
}

$mgmtCredFile = "$($env:APPDATA)\mgmtCreds.xml"
if (-not (Test-Path $mgmtCredFile)) {
    throw "Could not find '$mgmtCredFile'"
}

$mgmtCreds = Import-Clixml $mgmtCredFile
if (-not $mgmtCreds) {
    throw "Unable to import MGMT creds from '$mgmtCredFile'"
}

foreach ($domainTarget in $domainTargets) {
    $cmd = "$env:windir\system32\cmdkey.exe"
    $params = @()
    $params += "/add:$domainTarget"
    $params += "/user:$($mgmtCreds.UserName)"
    $params += "/pass:$($mgmtCreds.GetNetworkCredential().Password)"

    $action = "Setting credential password"
    Write-Output "Performing the operation `"$action`" on target `"$domainTarget`""
    Write-Output "`n$cmd $params"
    & $cmd $params
}
