# utility functions

function Get-ProjectUrl {
    param (
        [string]$projectPath
    )

    $projectUrl = Select-Xml -Path $projectPath -Namespace @{msb = "http://schemas.microsoft.com/developer/msbuild/2003" } -XPath "//msb:IISUrl" |
    Select-Object -Property @{Name = "IISUrl"; Expression = { $_.Node.InnerXml } } |
    Select-Object -ExpandProperty IISUrl
    return $projectUrl
}

function IsCorrectFramework {
    return (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 394802
}
function Find-File () {
    param (
        [string]$Search = ""
    )
    if ($Search) {
        Get-ChildItem -Recurse $($Search) | ForEach-Object { write "$($_.FullName)" }
    }
}
New-Alias ff Find-File

function Get-TargetFrameworkVersions () {
    Get-ChildItem -Filter *.*proj -Recurse | ForEach-Object {
        $csprojPath = $_.FullName
        $targetFramework = Select-Xml -Path $csprojPath -Namespace @{msb = "http://schemas.microsoft.com/developer/msbuild/2003" } -XPath "//msb:TargetFrameworkVersion" |
            Select-Object -Property @{Name = "TargetFrameworkVersion"; Expression = { $_.Node.InnerXml } } |
            Select-Object -ExpandProperty TargetFrameworkVersion
        $targetFrameworkForNuget = $targetFramework.Replace(".","").Replace("v","net")

        Write-Output "$csprojPath ($targetFramework) [$targetFrameworkForNuget]"
    }
    # Select-Xml -Namespace @{msb = "http://schemas.microsoft.com/developer/msbuild/2003" } -XPath "//msb:TargetFrameworkVersion" |
    # Select-Object -Property @{Name = "TargetFrameworkVersion"; Expression = { $_.Node.InnerXml } } |
    # Select-Object -ExpandProperty TargetFrameworkVersion
    # Select-Object -ExpandProperty TargetFrameworkVersion |
    # Group-Object

}


function Get-TFCloakStatus () {
    tf dir /folders | ? {$_.Contains("$") -and -not $_.Contains(":")} | % {$_.substring(1, $_.length - 1)} | % {tf workfold $_} | ? {$_.Contains("$")}
}

function Get-IpAddress {
    Get-NetIPAddress -AddressFamily IPv4 | ? { $_.IPAddress.StartsWith('10.') } | Select-Object -Property InterfaceAlias, IPAddress
    # [System.Net.Dns]::GetHostAddresses($env:computername) | ? { $_.AddressFamily -eq "InterNetwork" -and $_.IPAddressToString.StartsWith("10.") } | % { $_.IPAddressToString }
    # ([System.Net.Dns]::GetHostAddresses($env:computername)).IPAddressToString | ?{!$_.Contains(":") -and !$_.StartsWith("192")}
    # ((ipconfig) -match "IPv4").split(":")[1].trim();
}
New-Alias ip Get-IpAddress

function Get-TrDns {
    $ipAddress = Get-NetIPAddress -AddressFamily IPv4 | ? { $_.IPAddress.StartsWith('10.') } | Select-Object -Property InterfaceAlias, IPAddress
    Get-DnsClientServerAddress -AddressFamily IPv4 -InterfaceAlias $ipAddress.InterfaceAlias
}

function Set-TrDns {
    $ipAddress = Get-NetIPAddress -AddressFamily IPv4 | ? { $_.IPAddress.StartsWith('10.') } | Select-Object -Property InterfaceAlias, IPAddress
    # Set-DnsClientServerAddress -InterfaceAlias $ipAddress.InterfaceAlias -ServerAddresses ('10.202.102.4', '10.202.106.150')
    Set-DnsClientServerAddress -InterfaceAlias $ipAddress.InterfaceAlias -ServerAddresses ('10.204.50.29', '10.51.52.66')
    Get-DnsClientServerAddress -AddressFamily IPv4 -InterfaceAlias $ipAddress.InterfaceAlias
}

function iisresetDev () {
    @("10.202.97.46", "10.202.97.47", "10.202.97.48", "10.202.97.49")| % {Start-Process iisreset -ArgumentList "$_ /restart"}
}

function iisresetPD () {
    @("10.202.107.90", "10.202.107.90")| % {Start-Process iisreset -ArgumentList "$_ /restart"}
}

function rebootDev () {
    @("10.202.97.46", "10.202.97.47", "10.202.97.48", "10.202.97.49")| % {Start-Process shutdown -ArgumentList "/r /m \\$_"}
}

function Update-TrBams () {
    param (
        [string]$Search = ""
    )

    $searchTerm = "*.nupkg"

    if ($Search -ne "") {
        $searchTerm = "*$Search*.nupkg"
    }

    Get-ChildItem -Recurse $($searchTerm) | Sort-Object Name | ForEach-Object {nuget push $_.FullName}
}

function Update-NugetLocal () {
    param (
        [string]$Search = ""
    )

    $searchTerm = "*.nupkg"

    if ($Search -ne "") {
        $searchTerm = "*$Search*.nupkg"
    }

    Get-ChildItem -Recurse $($searchTerm) | Sort-Object Name | ForEach-Object {nuget add $_.FullName -source \\cr-velocityfs-0.tlr.thomson.com\Velocity\NuGet}
}
New-Alias unl Update-NugetLocal

function Get-ModulePathList {
    return $env:PSModulePath.replace(';;', ';').split(';');
}

function pathAsList {
    $pathList = $env:path.Replace("`;`;", "`;").Split("`;")
    $ht = @{}
    $pathList | ForEach-Object {$ht["$_"] += 1}
    $dupEntries = $ht.Keys | Where-Object {$ht["$_"] -gt 1}
    Write-Host "Path Entries (actual order)" -ForegroundColor Cyan
    $pathList | ForEach-Object {Write-Host "$_"}
    if ($dupEntries.Count -gt 0) {
    Write-Host "`nDuplicate Path Entries" -ForegroundColor Red
    $dupEntries | ForEach-Object { Write-Host "$_"}
    }
    Write-Host
}
function pathAsSortedList {
    Write-Output $env:path|ForEach-Object {$_.split(';')} | Sort-Object $_ | Get-Unique
}

function bfg {
    java -jar "C:\ProgramData\chocolatey\lib\bfg-repo-cleaner\tools\bfg-1.13.0.jar" $args
}

function mcd ([string]$Path) {
    if (-not $Path) {
        return;
    }
    mkdir $Path -ErrorAction SilentlyContinue
    if (Test-Path $Path) {
        Set-Location $Path
    }
}

function vmdir {
    param (
        [string]$DriveLetter
    )
    if ($DriveLetter -and $DriveLetter.Length -eq 1) {
        Remove-Item "~\VirtualBox VMs" -ErrorAction SilentlyContinue
        $vmPath = "$DriveLetter" + ':\VM'
        New-Item -Path "~\VirtualBox VMs" -ItemType Junction -Value $vmPath
    }
    $virtualBoxLink = Get-ChildItem -Path "~" -Filter "VirtualBox VMs*" | Select-Object Name, Target
    $existingDrives = Get-WmiObject win32_logicaldisk name, volumename, filesystem -Filter drivetype=3 | Select-Object FileSystem, Name, VolumeName

    Write-Output $virtualBoxLink
    Write-Output $existingDrives | Format-Table -Property Name, VolumeName
    
    # @echo off
    # IF %1.==. wmic logicaldisk get name,volumename,description,filesystem & dir /al "%userprofile%\VirtualBox VMs*" & exit /b 0
    # rd "%userprofile%\VirtualBox VMs" 
    # mklink /j "%userprofile%\VirtualBox VMs" %1:\VM

}

function Update-NugetPackages {
    Write-Output "Refreshing nuget packages..."
    # use rm.exe if possible
    if ($null -eq (Get-Command "rm.exe" -ErrorAction SilentlyContinue)) { 
        Remove-Item .\packages -Recurse -Force -ErrorAction SilentlyContinue
    }
    else {
        rm.exe -rf packages
    }
    # nuget locals all -clear
    # nuget restore -nocache
    nuget restore
}
New-Alias rn Update-NugetPackages

function Get-SolutionFile {
    $sln = $(Get-ChildItem *.sln | Select-Object -First 1 | ForEach-Object {$_.FullName})
    return $sln
}

function Start-VS2017 {
    $devenv = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe"
    $sln = Get-SolutionFile
    # $sln = $(dir *.sln | select -First 1 | % {$_.FullName})
    & $devenv $sln
}
New-Alias vs17 Start-VS2017

function Start-VS2019 {
    $devenv = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe"
    $sln = Get-SolutionFile
    & $devenv $sln
}
New-Alias vs19 Start-VS2019
New-Alias vs Start-VS2019

function Clean {
    Get-ChildItem -Recurse -include 'bin', 'obj', 'publish'|
        ForEach-Object {
        if ((Get-ChildItem $_.Parent.FullName | Where-Object { $_.Name -Like "*.sln" -or $_.Name -Like "*.*proj" }).Length -gt 0) {
            remove-item $_ -recurse -force -ErrorAction SilentlyContinue
            write-host deleted $_
        }
    }
}

function Build {
    param (
        [switch]$Release, 
        [switch]$Rebuild, 
        [switch]$Clean, 
        [switch]$RefreshNugetPackages
    )

    if (-not (Test-Path *.sln)) {
        throw "No solutions found to build"
    }

    $sln = Get-SolutionFile
    $msbuildPath = dir -path 'C:\Program Files (x86)\Microsoft Visual Studio' -Recurse msbuild.exe | ?{-not $_.FullName.Contains("amd64")} | Sort-Object $_.FullName -Descending | Select-Object -First 1 | %{$_.DirectoryName}


    if ($null -eq (Get-Command "MSBuild.exe" -ErrorAction SilentlyContinue)) { 
        $env:Path += ";$msbuildPath"
    }

    if ($Clean) {
        Clean
    }

    # Defaults
    $config = "Debug"
    $platform = "x64"

    if ($Release) {
        $config = "Release"
    }

    # Search the .sln file for x64 platform, if not found use default
    if ($platform -eq "x64") {
        if (Get-Content -raw $sln | ForEach-Object {$_ -notlike '*x64*'}) {
            $platform = $null
        }
    }

    if ($RefreshNugetPackages) {
        Update-NugetPackages
    }else {
        nuget restore
    }

    $cmd = "msbuild.exe"
    $params = @()
    $params += "$sln"
    if ($Rebuild) {
        $params += "/t:rebuild"
    }
    else {
        $params += "/t:build"
    }
    $params += "/p:StopOnFirstFailure=true"
    $params += "/p:configuration=$config"
    if ($platform) {
        $params += "/p:platform=`"$platform`""
    }

    & $cmd $params
    if ($LastExitCode -ne 0) {
        throw "Build Failed: $cmd $params"
    }
    Write-Output "Build Succeeded: $cmd $params"

    if ($Release -and (Test-Path .\release-build.ps1)) {
        . .\release-build.ps1
    }
}
function gitBash {
    & 'C:\Program Files\Git\git-bash.exe'
}
New-Alias gb gitBash

function whereis {
    $cmd = "where.exe"
    & $cmd $args
}
New-Alias whence whereis

# function whence {
#     return "$((Get-Command $args[0] -ErrorAction SilentlyContinue).Definition)"
# }

# function msbuild {
#     $cmd = Get-ChildItem -path 'C:\Program Files (x86)\Microsoft Visual Studio' -Recurse msbuild.exe | Sort-Object $_.FullName -Descending | Select-Object -First 1 | %{$_.FullName}
#     # $cmd = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe"
#     & $cmd $args
# }

function Start-NotepadPlusPlus {
    if (Test-Path "C:\Program Files (x86)\Notepad++\notepad++.exe") {
        Start-Process "C:\Program Files (x86)\Notepad++\notepad++.exe" $args
        return
    }

    if (Test-Path "C:\Program Files\Notepad++\notepad++.exe") {
        Start-Process "C:\Program Files\Notepad++\notepad++.exe" $args
        return
    }
}
New-Alias npp Start-NotepadPlusPlus

function Set-WindowTitle {
    $host.ui.RawUI.WindowTitle = $args[0]
}
New-Alias title Set-WindowTitle

function Get-DotNetVersion {
    param (
        [string]$filePath
    )
    $pathToDll = Resolve-Path $filePath
    [byte[]]$dllByteArray= [System.IO.File]::ReadAllBytes($pathToDll)
    $result = [Reflection.Assembly]::ReflectionOnlyLoad($dllByteArray).CustomAttributes | Where-Object {$_.AttributeType.Name -eq "TargetFrameworkAttribute" } | Select-Object -ExpandProperty ConstructorArguments | Select-Object -ExpandProperty value
    return $result
}

function Get-IISExpress {
    Get-Process -Name iisexpress | Format-Table id, mainwindowtitle -autosize
}

# function Get-SolutionPlatform {
#     $slns = Get-ChildItem *.sln -Recurse
#     # $results = @()
#     foreach ($sln in $slns) {
#         $slnContent = Get-Content -Raw $sln
#         $has64bit = $slnContent -match 'x64'
#         $result = @{"Has64bit" = $has64bit; "Filename" = $sln.FullName}
#         Write-Output $result
#         # $results += $result
#         # Write-Output "$has64bit `t $($sln.FullName)"
#     }

#     # $results
# }

function Start-Sleep($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}
