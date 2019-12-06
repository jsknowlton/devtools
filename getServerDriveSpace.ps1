$servers = @(
    "c009wdtotwsvc",
    "c027xfnotwsvc",
    "c067eedotwsvc",
    "c086frqotwsvc",
    "c125cxwotwsvc",
    "c175thvotwsvc",
    "c183jvzotwsvc",
    "c206kvnotwsvc",
    "c420cqqotwsvc",
    "c442fgmotwsvc",
    "c470dmmotwsvc",
    "c495jhaotwsvc",
    "c511zxgotwsvc",
    "c573vdrotwsvc",
    "c581qwwotwsvc",
    "c634uxrotwsvc",
    "c661yxcotwsvc",
    "c670kgbotwsvc",
    "c686mtkotwsvc",
    "c719bktotwsvc",
    "c741qunotwsvc",
    "c755tybotwsvc",
    "c785qjdotwsvc",
    "c805rmzotwsvc",
    "c826umyotwsvc",
    "c830rbuotwsvc",
    "c877qxmotwsvc",
    "c924wwmotwsvc",
    "c936vscotwsvc",
    "c981xqvotwsvc",
    "c995cnfotwsvc"
)

foreach ($server in $servers) {
    $serverStatus = $(Invoke-WebRequest -Uri "http://dc-asm.fasttax.com/WebServers/Info/sysmon.asp?SERVER=$server")
    $subject = $serverStatus.RawContent
    Write-Output "`n$($server.ToUpper())"

    $regex = [regex] '(?i)<td>(Drive [C|D]:.*)</td>'
    $matchdetails = $regex.Match($subject)
    while ($matchdetails.Success) {
        for ($i = 1; $i -lt $matchdetails.Groups.Count; $i++) {
            $groupdetails = $matchdetails.Groups[$i]
            if ($groupdetails.Success) {
                Write-Output "`t$($groupdetails.Value)"
            } 
        }
        $matchdetails = $matchdetails.NextMatch()
    } 
}