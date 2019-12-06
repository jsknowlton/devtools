param (
    [string]$server,
    [ValidateSet("1", "0", "")][string]$isActive = ""
)

$timeoutSecs = 5
$endpoint = 'online'
$method = 'Get'
$onlineStatus = ''

if ($isActive) {
    $method = 'Post'
    if ($isActive -eq "0") {
        $endpoint = 'offline'
    }
}

try {
    $onlineStatus = (Invoke-WebRequest -Uri "http://$($server):9004/healthcheck/$($endpoint)" -Method $method -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
}
catch {
    $onlineStatus = "exception"
}

Write-Output "$method`t$server`t$onlineStatus"
