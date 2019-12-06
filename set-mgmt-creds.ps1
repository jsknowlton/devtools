function UpdateCredentialManager {
    param(
        [parameter(ValueFromPipeline)] [pscredential] $Credential
    )
    
    if (-not $Credential) {
        return;
    }

    $domainTargets = @()
    $target = $null
    $user = $null
    $targetPrefix = "target: domain:target="
    $userPrefix = "user: "
    $cmd = "$env:windir\system32\cmdkey.exe"

    # get list of stored credentials and build dictionary of domain credentials
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
        $params += "/add:$($domainTarget)"
        $params += "/user:$($Credential.UserName)"
        $params += "/pass:$($Credential.GetNetworkCredential().Password)"

        $action = "Setting credential password"
        Write-Host "Performing the operation `"$action`" on target `"$domainTarget`""
        # Write-Host $cmd $params
        & $cmd $params 
    }
}

Get-Credential "mgmt\$($env:username.ToLower().Replace("u","m"))" | UpdateCredentialManager
