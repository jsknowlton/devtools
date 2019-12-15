param(
    [string] $targetFilePath
)
# PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\OTW\tr-tools\LaunchOTW_NS.ps1' %1"
# C:\OTW\tr-tools\LaunchOTW_NS.ps1
# localhost:57031/home/?openLocatorToken=-NS%3d~~10.202.106.215~D%3a~GSLocal~Locators~37777~1041~F6156KI7.DAT&locatorYear=2017&isOneSource=False&areaid=20&screenid=74
$modifiedFilePath = $targetFilePath.Replace("\","~").Replace("$","%3a")
$tempFileName = $modifiedFilePath.ToLower().Replace(".dat","")
$lastChar = $tempFileName[$tempFileName.Length - 1]
$locatorYear = "201$lastChar"
$locatorUrl = "http://localhost:57031/home/?openLocatorToken=-NS%3d$modifiedFilePath&locatorYear=$locatorYear&isOneSource=False"
# Write-Output "locatorYear: $locatorYear"
# Write-Output "Original Input: $targetFilePath"
# Write-Output "Modified Input: $modifiedFilePath"
# Write-Output "$locatorUrl"
Start-Process "$locatorUrl"
