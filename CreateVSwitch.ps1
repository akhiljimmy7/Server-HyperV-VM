$csv3 = Import-Csv "C:\Scripting\ENG01\HostNameIP_CreateVSwitch.csv" -Header "SrcIPaddress","Hostname" -Delimiter ","
#Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
$counter = 0
 

foreach($item in $csv3)
{

 

if ($counter -gt 0)
{

#uncomment this line to add new IP address to Trusted Host List if host no added to list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $item.SrcIPaddress -Concatenate
Write-Host $item.SrcIPaddress,$item.Hostname
Invoke-Command -ComputerName $item.SrcIPaddress -AsJob -ScriptBlock {

Param (
$item ) 

New-VMSwitch -name "New Virtual Switch" -NetAdapterName "Embedded FlexibleLOM 1 Port 1 2" -AllowManagementOS $true
#Restart Blade Host or the computer-VM


 

 

} -ArgumentList $item

 

 

}
$counter++
}