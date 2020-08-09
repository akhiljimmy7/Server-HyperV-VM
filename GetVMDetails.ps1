$Output= @()
    $names = Get-Content "C:\location\item\HostNames.txt"
    
    foreach ($name in $names){
     get-vm -ComputerName $name | ?{$_.State -eq "Running"} | select -ExpandProperty networkadapters | select vmname, macaddress, switchname, ipaddresses, computername, name
    
    $Output+= "$command1"
    }
   # }
  
