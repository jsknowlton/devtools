#
# EncryptionServiceTest.ps1
#
$appServer = '10.206.159.51'
$sessionId = '928759'
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
$GoSystemWebSecurityUrl_SI = 'http://si-gosyssecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PL = 'http://pl-gosystemwebsecurity.int.thomsonreuters.com:8100'
$GoSystemWebSecurityUrl_PL1 = 'http://10.185.7.25:8100'
$GoSystemWebSecurityUrl_PL2 = 'http://10.185.7.26:8100'
$GoSystemWebSecurityUrl_PL3 = 'http://10.185.7.27:8100'
$GoSystemWebSecurityUrl_PL4 = 'http://10.185.7.28:8100'
$GoSystemWebSecurityUrl_DC = 'http://dc-gosystemwebsecurity.int.thomson.com:8100'
$GoSystemWebSecurityUrl = $GoSystemWebSecurityUrl_SAT

$encryptedToken = "6jzGxvoKS402rzZsFAxQ9kcNznIqp165rbfOyaHxRrWoMpWVnUdnADeZNkEOn0wn9umuYiThPpq2PsAYyHpwQSg9xQiXS4vbpEVMGUCpESJ7st+LCj/YU+DVheqyfTZ7"
write-host "encryptedToken=$encryptedToken"
write-host "Invoke-WebRequest -Uri $GoSystemWebSecurityUrl/decrypt"
$decryptedToken = Invoke-WebRequest -Uri "$GoSystemWebSecurityUrl/decrypt" -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($encryptedToken)) -ContentType 'text/plain; charset=utf-8'
write-host "decryptedToken=$decryptedToken`n"
