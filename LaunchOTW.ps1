#
# LaunchOTW.ps1
#
$appServer = '10.114.4.139'
$sessionId = '899863'
$nameSpace = 'GRS'
$taxYear = '2018'

$otwUrl_local = 'http://localhost:57031'
$otwUrl_td1 = 'https://dev2.onesourcetax.com/oit/web-organizer-sitd1'
# $otwUrl_pl = 'http://10.185.26.47'
$otwUrl_pl = 'http://organizertoweb-pl.int.thomsonreuters.com'
$otwUrl_sandbox = 'https://sandbox-organizertoweb.fasttax.com'
$otwUrl = $otwUrl_local

$GoSystemWebSecurityUrl_SAT = 'http://sat-lafiutil.int.thomsonreuters.com:8100/'
$GoSystemWebSecurityUrl_PD = 'http://pd-lafiutil.int.thomsonreuters.com:8100/'
$GoSystemWebSecurityUrl_SI = 'http://si-gosyssecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PL = 'http://pl-gosystemwebsecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_SANDBOX = 'http://sandbox-lafiwebsvc.int.thomson.com:8100/'
$GoSystemWebSecurityUrl_SB = 'http://sb-lafiwebsvc.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_DC = 'http://dc-gosystemwebsecurity.int.thomson.com:8100/'
$GoSystemWebSecurityUrl = $GoSystemWebSecurityUrl_SI

$clearToken = "APPSERVER=$appServer,NAMESPACE=$nameSpace,SESSIONID=$sessionId,YEAR=$taxYear"
write-host "Invoke-WebRequest -Uri $GoSystemWebSecurityUrl/encrypt"
$encryptedToken = Invoke-WebRequest -Uri "$GoSystemWebSecurityUrl/encrypt" -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($clearToken)) -ContentType 'text/plain; charset=utf-8'
write-host "$otwUrl/?openlocatortoken=$encryptedToken"
"$otwUrl/?isOneSource=false&openlocatortoken=$encryptedToken" | Set-Clipboard
start "$otwUrl/?isOneSource=false&openlocatortoken=$encryptedToken"
