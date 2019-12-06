#Requires -RunAsAdministrator

<#
.NOTES
  Version:        1.0
  Author:         Jeff Knowlton
  Creation Date:  2019-02-27
  Purpose/Change: Set up an OTW developer machine
#>

# Ensure chocolatey is installed
if ($null -eq (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
    choco feature enable -n=allowGlobalConfirmation
    choco feature enable -n=failOnAutoUninstaller
    choco feature enable -n=useRememberedArgumentsForUpgrades
    refreshenv
}

# Ensure nuget is installed
if ($null -eq (Get-Command "nuget.exe" -ErrorAction SilentlyContinue)) {
    choco install nuget.commandline
}

# Ensure nodejs and grunt are installed
if ($null -eq (Get-Command "node.exe" -ErrorAction SilentlyContinue)) {
    choco install nodejs.install -Version 11.6.0
    $env:Path += ";$env:ProgramFiles\nodejs"
    # npm config set proxy http://webproxy.int.westgroup.com
    # npm config set https-proxy http://webproxy.int.westgroup.com
    npm install -g npmlist
    npm install -g grunt@0.4.5
    npm install -g grunt-cli@1.2.0
}

# --------------------------------
# Set credentials for nuget repo
# --------------------------------
$tenCreds = $host.ui.PromptForCredential("Need TEN credentials for BAMS NuGet Repository", "Please enter your firstname.lastname and TEN password.", "", "")
if (-not $tenCreds) {
    throw "No credentials entered"
}

$cmd = "nuget.exe"
$params = @()
$params += "source"
$params += "add"
$params += "-name"
$params += "BAMS-Cloud"
$params += "-source"
$params += "https://bams-aws.refinitiv.com/artifactory/api/nuget/default.nuget.cloud"
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

$params = @()
$params += "source"
& $cmd $params

# ------------------------------------------------------------------
# Ensure git is installed
# ------------------------------------------------------------------
if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
    choco install git.install --params "/GitAndUnixToolsOnPath /SChannel"
    $env:Path += ";$env:programfiles\git\cmd"
}

# ------------------------------------------------------------------
# Use git to clone webservice, website and pdf service repositories
# ------------------------------------------------------------------
Write-Output "`n`nUsing git to clone webservice, website and pdf service repositories"
$tenUserName = $env:USERNAME
if ($env:USERDOMAIN.ToUpper() -ne "TEN") {
    $tenUserName = Read-Host -Prompt "Please enter your TEN username (Uxxxxxxx)"
}
$parts = $tenUserName.Split("\")
if ($parts.Length -gt 1) {
    $tenUserName = $parts[1]
}else {
    $tenUserName = $parts[0]
}
$tenUserName = "ten\$tenUserName"
$gitRepos = @(
    "http://$tenUserName@tfstta.int.thomsonreuters.com:8080/tfs/DefaultCollection/USIncomeTax.WebOrganizer/_git/TRTA.WebPrint.PrintFileConverter",
    "http://$tenUserName@tfstta.int.thomsonreuters.com:8080/tfs/DefaultCollection/USIncomeTax.WebOrganizer/_git/TRTA.WebOrganizer.Webservice",
    "http://$tenUserName@tfstta.int.thomsonreuters.com:8080/tfs/DefaultCollection/USIncomeTax.WebOrganizer/_git/TRTA.WebOrganizer.Website"
)
$otwRoot = "C:\OTW"
mkdir $otwRoot *> $null
Push-Location $otwRoot
foreach ($gitRepo in $gitRepos) {
    $cmd = "git.exe"
    $params = @()
    $params += "clone"
    $params += $gitRepo
    & $cmd $params
}