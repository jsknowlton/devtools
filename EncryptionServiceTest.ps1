#
# EncryptionServiceTest.ps1
#
$appServer = '10.202.107.200'
$sessionId = '3804887'
$nameSpace = 'GRS'
$taxYear = '2018'

$GoSystemWebSecurityUrl_SANDBOX = 'http://sandbox-lafiwebsvc.int.thomson.com:8100'
$GoSystemWebSecurityUrl_SB = 'http://sb-lafiwebsvc.int.thomsonreuters.com:8100'
# $GoSystemWebSecurityUrl_SB1 = 'http://10.206.159.28:8100'
$GoSystemWebSecurityUrl_SB1 = 'http://10.206.159.57:8100'
$GoSystemWebSecurityUrl_SB2 = 'http://10.206.159.70:8100'
# $GoSystemWebSecurityUrl_SB2 = 'http://10.206.159.75:8100'
$GoSystemWebSecurityUrl_SAT = 'http://sat-lafiutil.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PD = 'http://pd-lafiutil.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PD1 = 'http://10.202.104.144:8100'
$GoSystemWebSecurityUrl_PD2 = 'http://10.202.104.149:8100'
$GoSystemWebSecurityUrl_SI = 'http://si-gosyssecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PQ = 'http://pq-gosyssecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PL = 'http://pl-gosystemwebsecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PL1 = 'http://10.185.7.25:8100'
$GoSystemWebSecurityUrl_PL2 = 'http://10.185.7.26:8100'
$GoSystemWebSecurityUrl_PL3 = 'http://10.185.7.27:8100'
$GoSystemWebSecurityUrl_PL4 = 'http://10.185.7.28:8100'
$GoSystemWebSecurityUrl_AWS = 'https://lafi-websvc-dr-use1-aws.tax.prod.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_DC = 'http://dc-gosystemwebsecurity.int.thomson.com:8100'
$GoSystemWebSecurityUrl_encrypt = $GoSystemWebSecurityUrl_PQ
$GoSystemWebSecurityUrl_decrypt = $GoSystemWebSecurityUrl_PQ

$clearToken = "APPSERVER=$appServer,NAMESPACE=$nameSpace,SESSIONID=$sessionId,YEAR=$taxYear"
write-host "clearToken=$clearToken"
write-host "Invoke-WebRequest -Uri $GoSystemWebSecurityUrl_encrypt/encrypt"
$encryptedToken = Invoke-WebRequest -Uri "$GoSystemWebSecurityUrl_encrypt/encrypt" -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($clearToken)) -ContentType 'text/plain; charset=utf-8'
write-host "encryptedToken=$encryptedToken"
write-host "Invoke-WebRequest -Uri $GoSystemWebSecurityUrl_decrypt/decrypt"
$decryptedToken = Invoke-WebRequest -Uri "$GoSystemWebSecurityUrl_decrypt/decrypt" -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($encryptedToken)) -ContentType 'text/plain; charset=utf-8'
write-host "decryptedToken=$decryptedToken`n"
