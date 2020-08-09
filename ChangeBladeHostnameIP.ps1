$csv3 = Import-Csv "C:\location\item\HostDetails.csv" -Header "SrcIPaddress","Hostname","TgtIPAddress","SubnetMask","DefaultGateway" -Delimiter ","
#Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
$counter = 0
foreach($item in $csv3)
{
if ($counter -gt 0)
{
#uncomment this line to add new IP address to Trusted Host List if host no added to list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $item.SrcIPaddress -Concatenate -force
Write-Host $item.SrcIPaddress,$item.TgtIPaddress,$item.Hostname,$item.SubnetMask,$item.DefaultGateway
Invoke-Command -ComputerName $item.SrcIPaddress -AsJob -ScriptBlock {
Param (
$item )
#Renaming Computer Hostname
Rename-Computer -NewName $item.Hostname

Write-Host $item.SrcIPaddress,$item.TgtIPaddress,$item.Hostname,$item.SubnetMask,$item.DefaultGateway
netsh interface ip set address "Network Adapter Name" static $item.TgtIPAddress $item.SubnetMask $item.DefaultGateway
netsh interface ip set dns "Network Adapter Name" static 172.16.0.10
netsh interface ip add dns "Network Adapter Name" 172.16.0.20
netsh interface ip set wins name="Network Adapter Name" source=static addr=172.16.0.30
Disable-NetAdapterBinding -Name "Network Adapter Name" -ComponentID ms_tcpip6
#restart server

Restart-Computer -Force
} -ArgumentList $item
}
$counter++
}
