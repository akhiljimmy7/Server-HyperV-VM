$csv3 = Import-Csv "C:\Scripting\ENG01\VMDetails.csv" -Header "SrcIPaddress","Hostname","TgtIPAddress","SubnetMask","DefaultGateway" -Delimiter ","
#Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
$counter = 0

 

foreach($item in $csv3)
{

 

if ($counter -gt 0)
{

 

#uncomment this line to add new IP address to Trusted Host List if host no added to list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $item.SrcIPaddress -Concatenate
Write-Host $item.SrcIPaddress,$item.TgtIPaddress,$item.Hostname,$item.SubnetMask,$item.DefaultGateway

 

 

 

Invoke-Command -ComputerName $item.SrcIPaddress -AsJob -ScriptBlock {

 

Param (
$item )

 

Rename-Computer -NewName $item.Hostname

 

Write-Host $item.SrcIPaddress,$item.TgtIPaddress,$item.Hostname,$item.SubnetMask,$item.DefaultGateway

 

netsh interface ip set address "Ethernet" static $item.TgtIPAddress $item.SubnetMask $item.DefaultGateway
netsh interface ip set dns "Ethernet" static 172.16.0.220
netsh interface ip add dns "Ethernet" 172.16.0.14
netsh interface ip set wins name="Ethernet" source=static addr=172.16.0.30


netsh interface ip set address "Ethernet 3" static $item.TgtIPAddress $item.SubnetMask $item.DefaultGateway
netsh interface ip set dns "Ethernet 3" 172.16.0.220
netsh interface ip add dns "Ethernet 3" 172.16.0.14
netsh interface ip set wins name="Ethernet 3" source=static addr=172.16.0.30

 


Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6
Disable-NetAdapterBinding -Name "Ethernet 3" -ComponentID ms_tcpip6
 

 

#restart server
Restart-Computer -Force

 

 

} -ArgumentList $item

 

 

}
$counter++
}