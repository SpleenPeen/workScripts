#find driver name of hotkey service
$all = Get-CimInstance -ClassName Win32_PnPSignedDriver;
$name = "";
foreach ($curDev in $all) 
{ 
 if ($curDev.DeviceName -like "HP LAN/WLAN/WWAN Switching and Hotkey Service") 
 { 
  $name =  $curDev.InfName; 
 } 
}

#delete driver (if found)
if ($name -ne "") { pnputil /delete-driver $name /uninstall /force; }

#add stable driver from folder
$driver = $PSScriptRoot + "/Driver/HpqKbSoftwareCompnent.inf"
pnputil /add-driver $driver /install