$Output= @()
    $names = Get-Content "C:\Scripting\ENG01\HostNames.txt"
    #$command1=get-vm -ComputerName $name | ?{$_.State -eq "Running"} | select -ExpandProperty networkadapters | select vmname, macaddress, switchname, ipaddresses, computername
    foreach ($name in $names){
   # Invoke-Command -ComputerName $name -AsJob -ScriptBlock {
   # $out1=get-vmnetworkadapter -All -ComputerName $name | Select ipaddresses
     get-vm -ComputerName $name | ?{$_.State -eq "Running"} | select -ExpandProperty networkadapters | select vmname, macaddress, switchname, ipaddresses, computername, name
    # Get-VMNetworkAdapter -ComputerName $name | select name 
    $Output+= "$command1"
    }
   # }
  