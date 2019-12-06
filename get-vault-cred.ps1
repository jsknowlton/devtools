[CmdletBinding(SupportsShouldProcess)]
param(
    [switch] $updateCredFile,
    [switch] $forceUpdate
)
$ErrorActionPreference = 'Stop'
Import-Module -Name psPAS
$updateCredentialManager = $true

function UpdateCredentialManager {
    param(
        [parameter(ValueFromPipeline)] [pscredential] $Credential
    )
    $domainTargets = @()
    $target = $null
    $user = $null
    $targetPrefix = "target: domain:target="
    $userPrefix = "user: "
    $cmd = "cmdkey.exe"

    # get list of stored credentials and build dictionary of MGMT credentials
    cmdkey.exe /list | ForEach-Object {
        $outputLine = $_.trim().ToLower()
        if ($outputLine.StartsWith($targetPrefix)) {
            $target = $outputLine.Replace($targetPrefix, "")
            $user = $null
        }
    
        if ($outputLine.StartsWith($userPrefix)) {
            $user = $outputLine.Replace($userPrefix, "")
            if ($user -like $($Credential.UserName)) {
                $domainTargets += $target
            }
            $target = $null
            $user = $null
        }
    }

    foreach ($domainTarget in $domainTargets) {
        $params = @()
        $params += "/add:$domainTarget"
        $params += "/user:$($Credential.UserName)"
        $params += "/pass:$($Credential.GetNetworkCredential().Password)"

        $action = "Setting credential password"
        Write-Host "Performing the operation `"$action`" on target `"$domainTarget`""
        # Write-Host $cmd $params
        & $cmd $params 
    }
}

$tenCredFile = "$($env:APPDATA)\tenCreds.xml"
if (-not (Test-Path $tenCredFile) -or $updateCredFile) {
    # $tenCreds = Get-Credential -Message 'Enter your TEN account credentials:' -UserName "$($env:username.ToUpper())"
    $tenCreds = Get-Credential -Message 'Enter your TEN account credentials:'
    $tenCreds | Export-Clixml $tenCredFile
}

$tenCreds = Import-Clixml $tenCredFile
$tenCredsUserName = $tenCreds.UserName.ToUpper()
Write-Host "tenCredsUserName = $tenCredsUserName"
$mgmtUserName = $tenCredsUserName.Replace("U", "M")
Write-Host "mgmtUserName = $mgmtUserName"
$vaultUri = 'https://thevault.int.thomsonreuters.com'

Write-Host "Getting MGMT credentials from The Vault..."
$vaultToken = New-PASSession -Credential $tenCreds -BaseURI $vaultUri -PVWAAppName 'PasswordVault' -UseRadiusAuthentication $true
if (-not $vaultToken) {
    throw 'Could not retrieve vault token.'
}

$mgmtPassword = $vaultToken |
    Get-PASAccount -Keywords $mgmtUserName |
    Get-PASAccountPassword |
    Select-Object -ExpandProperty Password

if (-not $mgmtPassword) {
    throw 'Could not retrieve the password.'
}
$mgmtPassword | Set-Clipboard
$mgmtUserName = "mgmt\$($mgmtUserName.ToLower())"

# Get previous MGMT password, only update credential manager if password changed
$mgmtCredFile = "$($env:APPDATA)\mgmtCreds.xml"
if (Test-Path $mgmtCredFile) {
    $mgmtCreds_previous = Import-Clixml $mgmtCredFile
    $mgmtPassword_previous = $mgmtCreds_previous.GetNetworkCredential().Password
    $passwordChanged = -not ($mgmtPassword -ceq $mgmtPassword_previous)
    $updateCredentialManager = $passwordChanged
    # Write-Host "Old Password: $mgmtPassword_previous"
    # Write-Host "New Password: $mgmtPassword"
    # Write-Host "Password Changed? = $passwordChanged"
}

# Save MGMT creds safely
$mgmtPassword = convertto-securestring -String $mgmtPassword -AsPlainText -Force
$mgmtCreds = new-object -typename System.Management.Automation.PSCredential -argumentlist $mgmtUserName, $mgmtPassword
$mgmtCreds | Export-Clixml $mgmtCredFile

if (($updateCredentialManager) -or ($forceUpdate)) {
    $mgmtCreds | UpdateCredentialManager
}

Remove-Variable -Name mgmtPassword -ErrorAction Ignore
