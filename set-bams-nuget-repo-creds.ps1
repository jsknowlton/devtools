<#
.NOTES
  Version:        1.0
  Author:         Jeff Knowlton
  Creation Date:  2019-02-27
  Purpose/Change: Simplify adding/updating credentials for nuget repo
#>
param (
    [ValidateSet("global", "cloud", "local", "all")][string]$repo = "cloud"
)

$repos = @($repo)
if ($repo -eq "all") {
    $repos = @("global", "cloud", "local")
}

# Make sure chocolatey and nuget are installed
if ($null -eq (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    $code = {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
        choco feature enable -n=allowGlobalConfirmation
        choco feature enable -n=failOnAutoUninstaller
        choco feature enable -n=useRememberedArgumentsForUpgrades
        choco install nuget.commandline
    }
    Start-Process -FilePath powershell.exe -ArgumentList $code -verb RunAs -WorkingDirectory C:
}

$tenCreds = $host.ui.PromptForCredential("BAMS requires TEN credentials", "Please enter your firstname.lastname and TEN password.", "", "")
if (-not $tenCreds) {
    throw "No credentials entered"
}

foreach ($nugetRepo in $repos) {
    $cmd = "nuget.exe"
    $params = @()
    $params += "source"
    $params += "add"
    $params += "-name"
    $params += "BAMS-$nugetRepo"
    $params += "-source"
    $params += "https://bams-aws.refinitiv.com/artifactory/api/nuget/default.nuget.$nugetRepo"
    $params += "-username"
    $params += $tenCreds.UserName
    $params += "-password"
    $params += $tenCreds.GetNetworkCredential().Password
    
    & $cmd $params *> $null
    if ($LastExitCode -ne 0) {
        # We attempt to 'add' first. If 'add' fails we 'update' instead
        $params[1] = "update"
        & $cmd $params *> $null
    }
}

$params = @()
$params += "source"
& $cmd $params
