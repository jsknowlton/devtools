param (
    [switch]$continuous
)

[array]$servers = @(
    # "c050kaygrsapp.clrrs.loc:9004",
    # "c154itigrsapp.clrrs.loc:9004",
    # "c210daogrsapp.clrrs.loc:9004",
    # "c223svwgrsapp.clrrs.loc:9004",
    # "c247eghgrsapp.clrrs.loc:9004",
    # "c270ynsgrsapp.clrrs.loc:9004",
    # "c611lsvgrsapp.clrrs.loc:9004",
    # "c625oobgrsapp.clrrs.loc:9004",
    # "c713kwigrsapp.clrrs.loc:9004",
    # "c732zlzgrsapp.clrrs.loc:9004",
    # "c765ezagrsapp.clrrs.loc:9004",
    # "c765xeugrsapp.clrrs.loc:9004",
    # "c766pgwgrsapp.clrrs.loc:9004",
    # "c770doygrsapp.clrrs.loc:9004",
    # "c772nbmgrsapp.clrrs.loc:9004",
    # "c775omdgrsapp.clrrs.loc:9004",
    # "c775ydcgrsapp.clrrs.loc:9004",
    # "c776gtegrsapp.clrrs.loc:9004",
    # "c777xekgrsapp.clrrs.loc:9004",
    # "c778jpngrsapp.clrrs.loc:9004",
    # "c780wmpgrsapp.clrrs.loc:9004",
    # "c784mgzgrsapp.clrrs.loc:9004",
    # "c785dqugrsapp.clrrs.loc:9004",
    # "c786lxrgrsapp.clrrs.loc:9004",
    # "c787zktgrsapp.clrrs.loc:9004",
    # "c788uokgrsapp.clrrs.loc:9004",
    # "c800jqogrsapp.clrrs.loc:9004",
    # "c801gvjgrsapp.clrrs.loc:9004",
    # "c802upqgrsapp.clrrs.loc:9004",
    # "c804rkegrsapp.clrrs.loc:9004",
    # "c804vrbgrsapp.clrrs.loc:9004",
    # "c805pzogrsapp.clrrs.loc:9004",
    # "c807sbogrsapp.clrrs.loc:9004",
    # "c810rrdgrsapp.clrrs.loc:9004",
    # "c811jcogrsapp.clrrs.loc:9004",
    # "c812zsigrsapp.clrrs.loc:9004",
    # "c813fchgrsapp.clrrs.loc:9004",
    # "c814haxgrsapp.clrrs.loc:9004",
    # "c815bhtgrsapp.clrrs.loc:9004",
    # "c822dxpgrsapp.clrrs.loc:9004",
    # "c822dxxgrsapp.clrrs.loc:9004",
    # "c824vgvgrsapp.clrrs.loc:9004",
    # "c827hxegrsapp.clrrs.loc:9004",
    # "c830cafgrsapp.clrrs.loc:9004",
    # "c831iwwgrsapp.clrrs.loc:9004",
    # "c833ffegrsapp.clrrs.loc:9004",
    # "c833mytgrsapp.clrrs.loc:9004",
    # "c841kpygrsapp.clrrs.loc:9004",
    # "c843uaxgrsapp.clrrs.loc:9004",
    # "c845uvlgrsapp.clrrs.loc:9004",
    # "c846gyugrsapp.clrrs.loc:9004",
    # "c846xcvgrsapp.clrrs.loc:9004",
    # "c846zndgrsapp.clrrs.loc:9004",
    # "c847hiwgrsapp.clrrs.loc:9004",
    # "c847iwlgrsapp.clrrs.loc:9004",
    # "c848ciagrsapp.clrrs.loc:9004",
    # "c852kjrgrsapp.clrrs.loc:9004",
    # "c853pdigrsapp.clrrs.loc:9004",
    # "c854kysgrsapp.clrrs.loc:9004",
    # "c854umdgrsapp.clrrs.loc:9004",
    # "c854uwrgrsapp.clrrs.loc:9004",
    # "c856zzngrsapp.clrrs.loc:9004",
    # "c862etpgrsapp.clrrs.loc:9004",
    # "c864fbmgrsapp.clrrs.loc:9004",
    # "c867tnygrsapp.clrrs.loc:9004",
    # "c871knugrsapp.clrrs.loc:9004",
    # "c873nezgrsapp.clrrs.loc:9004",
    # "c875iwrgrsapp.clrrs.loc:9004",
    # "c875uvmgrsapp.clrrs.loc:9004",
    # "c875wjcgrsapp.clrrs.loc:9004",
    # "c875ziigrsapp.clrrs.loc:9004",
    # "c877pmlgrsapp.clrrs.loc:9004",
    # "c877xgpgrsapp.clrrs.loc:9004",
    # "c880sgbgrsapp.clrrs.loc:9004",
    # "c881eimgrsapp.clrrs.loc:9004",
    # "c881phjgrsapp.clrrs.loc:9004",
    # "c884jqrgrsapp.clrrs.loc:9004",
    # "c888teigrsapp.clrrs.loc:9004"
)

# [array]$servers = @(
#     "c884pukgrsapp.clrrs.loc:9004",
#     "c050kaygrsapp.clrrs.loc:9004",
#     "c154itigrsapp.clrrs.loc:9004",
#     "c210daogrsapp.clrrs.loc:9004",
#     "c223svwgrsapp.clrrs.loc:9004",
#     "c886dsggrsapp.clrrs.loc:9004",
#     "c247eghgrsapp.clrrs.loc:9004",
#     "c270ynsgrsapp.clrrs.loc:9004",
#     "c611lsvgrsapp.clrrs.loc:9004",
#     "c891msxgrsapp.clrrs.loc:9004",
#     "c625oobgrsapp.clrrs.loc:9004",
#     "c713kwigrsapp.clrrs.loc:9004",
#     "c732zlzgrsapp.clrrs.loc:9004"
# )

$timeoutSecs = 5
. .\Invoke-Parallel.ps1

do {
    $results = invoke-parallel -InputObject $servers -throttle 20 -runspaceTimeout 30 -ImportVariables -ImportModules -Quiet -ScriptBlock {
        # $servers | ForEach-Object {
        $server = $_
        $serverName = $server.Split(".")[0]
        [array]$serverParts = $server.Split(":")

        try {
            $TimeTaken = 0
            $onlineStatus = "1"
            $ipaddress = ""
            $Start = 0     
            $End = 0

            $ipaddress = ([System.Net.Dns]::GetHostAddresses($serverParts[0])).IPAddressToString
            $port = 80
            if ($serverParts.Length -gt 1) {
                $port = $serverParts[1]
            }
    
            $Start = Get-Date
            # $onlineStatus = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/online" -Method Get -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
            $onlineStatus = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/offline" -Method Post -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
            $End = Get-Date
            $TimeTaken = ($End - $Start).TotalMilliseconds
        }
        catch {
            $onlineStatus = "exception"
            $TimeTaken = 0
            if ($Start) {
                $TimeTaken = ($(Get-Date) - $Start).TotalMilliseconds
            }
        }

        if (!$ipaddress) {
            $ipaddress = "unknown host"
        }

        $output = New-Object -TypeName PSObject -Property @{
            ServerName   = $serverName; 
            IpAddress    = $ipaddress;
            OnlineStatus = $onlineStatus;
            ElapsedTime  = $TimeTaken;   
        }
        return $output
    }

    Write-Output "Prod PdfSvc Online Status"
    Write-Output $results | Sort-Object -Property ServerName | Format-Table -Property ServerName, IpAddress, OnlineStatus, ElapsedTime
    Write-Output "Number of servers = $($results.Length)"
    Write-Output ""
} until (!$continuous)
