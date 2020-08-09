$csv3 = Import-Csv "C:\Scripting\ENG01\ChangeHyperVvmName.csv" -Header "Hostname","HostIP","CurrentVM1Name","CurrentVM2Name","VM1Name","VM2Name" -Delimiter ","
#Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
$counter = 0
 

foreach($item in $csv3)
{

 

if ($counter -gt 0)
{

#uncomment this line to add new IP address to Trusted Host List if host no added to list
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $item.HostIP -Concatenate
Write-Host $item.HostIP,$item.Hostname
Invoke-Command -ComputerName $item.HostIP -AsJob -ScriptBlock {

Param (
$item ) 

Rename-VM -Name $item.CurrentVM1Name -NewName $item.VM1Name
Rename-VM -Name $item.CurrentVM2Name -NewName $item.VM2Name

Write-Host $item.HostIP,$item.Hostname

#Restart Blade Host or the computer-VM
#Restart-Computer -Force

 

 

} -ArgumentList $item

 

 

}
$counter++
}