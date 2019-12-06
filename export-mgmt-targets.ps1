$ErrorActionPreference = 'Stop'

function GetMgmtTargets {
    param(
        [parameter(ValueFromPipeline)] [string] $mgmtUserName
    )
    $domainTargets = @()
    $target = $null
    $user = $null
    $targetPrefix = "target: domain:target="
    $userPrefix = "user: "
    $cmd = "$env:windir\system32\cmdkey.exe"

    # get list of stored credentials and build dictionary of domain credential targets
    & $cmd /list | ForEach-Object {
        $outputLine = $_.trim().ToLower()
        if ($outputLine.StartsWith($targetPrefix)) {
            $target = $outputLine.Replace($targetPrefix, "")
            $user = $null
        }
    
        if ($outputLine.StartsWith($userPrefix)) {
            $user = $outputLine.Replace($userPrefix, "")
            if ($user -like $($mgmtUserName)) {
                $domainTargets += $target
            }
            $target = $null
            $user = $null
        }
    }
    return $domainTargets
}

$mgmtCredFile = "$env:APPDATA\mgmtCreds.xml"
if (-not (Test-Path $mgmtCredFile)) {
    throw "Could not find '$mgmtCredFile'"
}

$mgmtCreds = Import-Clixml $mgmtCredFile
if (-not $mgmtCreds) {
    throw "Unable to import MGMT creds from '$mgmtCredFile'"
}

$mgmtTargets = GetMgmtTargets $mgmtCreds.UserName
Write-Output $mgmtTargets
