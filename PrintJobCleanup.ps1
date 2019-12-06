param (
    [Parameter(Position = 0, Mandatory = 1)]
    [string] $rootPath,
    [int] $daysHeld
)

Get-ChildItem $rootPath -Recurse -Directory |
    Where-Object { 
        $_.lastwriteTime -lt (Get-Date).AddHours(-72) -and $_.Name -match '[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-Z0-9]{12}' 
    } | 
        ForEach-Object { 
            echo"Removing $($_.FullName) $($_.CreationTime)"; 
            Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue 
        }
