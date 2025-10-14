	#Reset policy
if (test-path -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs") { Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs" -Name 1 -Force }

	#Remove drivers and install working one
$toRemove = Get-WindowsDriver -Online | where-object {$_.ClassName -like "SoftwareComponent" -and $_.ProviderName -like "HP *"}

foreach ($cur in $toRemove) 
{ 
 pnputil /delete-driver $cur.Driver /uninstall; 
 pnputil /delete-driver $cur.Driver /force;
}

pnputil /add-driver "$PSScriptRoot\Driver\HpqKbSoftwareCompnent.inf" /install;


	#Change policy
if(-not(test-path -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall")) 
{ 
 new-item -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name DeviceInstall
}

if(-not(test-path -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions")) 
{ 
 new-item -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall" -Name Restrictions;
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Name DenyDeviceIDs -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Name DenyDeviceIDsRetroactive -Value 0 -PropertyType DWORD -Force

if(-not(test-path -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs")) 
{ 
 new-item -path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Name DenyDeviceIDs;
}

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs" -Name "1" -Value "SWC\HPHKS&SRVCS"


	#Setup script
if(-not($PSScriptRoot -like "C:\Windows\Setup\Scripts")) {
if(-not(test-path -path "c:\Windows\Setup\Scripts")){New-Item -Path "c:\Windows\Setup\" -Name "Scripts" -ItemType Directory}
copy-item -path  "$PSScriptRoot\SetupComplete.cmd" -destination "C:/windows/setup/scripts" -force;
copy-item -path  "$PSScriptRoot\fixHot.ps1" -destination "C:/windows/setup/scripts" -force;
copy-item -path  "$PSScriptRoot\Driver" -destination "C:/windows/setup/scripts" -recurse -force;
}