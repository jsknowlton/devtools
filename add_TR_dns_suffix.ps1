# This key is used for domain machines
# $key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'

# This key is used for non-domain machines
$key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'

$newDomains = @(
	"int.thomsonreuters.com",
	"riaqa.loc",
	"clrrs.loc",
	"pqrs.thomson.com"
)

# Get existing search list
$dnsSearchList = (Get-DnsClientGlobalSetting).SuffixSearchList
# Add list of domains to search list
$dnsSearchList += $newDomains
# Remove duplicates from search list
$dnsSearchList = $dnsSearchList | Select-Object -Unique
# Create comma delimited string from list
$dnsSearchListString = $dnsSearchList -join ","
# Set registry key with new search list
Set-ItemProperty -Path $key -Name SearchList -Value $dnsSearchListString

ipconfig /registerdns *> $null
# sleep 5
ipconfig /flushdns *> $null
# sleep 5
# ipconfig /all
(Get-DnsClientGlobalSetting).SuffixSearchList
