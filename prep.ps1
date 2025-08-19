	#PREVENT FROM GOING TO SLEEP
powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0

	#LIST OF APPS TO NOT REMOVE
$whitelist = @(
"Microsoft.Windows",
"MicrosoftWindows",
"Microsoft.",
"\Windows\",
"Intel",
"AMD",
"MSTeams",
"Clipchamp",
"Thunderbolt"
)

$win10 = @(
"Microsoft.549981C3F5F10",
"Microsoft.SkypeApp",
"Microsoft.WindowsAlarms",
"microsoft.windowscommunicationsapps",
"Microsoft.BingWeather",
"Microsoft.DesktopAppInstaller",
"Microsoft.GetHelp",
"Microsoft.Getstarted",
"Microsoft.HEIFImageExtension",
"Microsoft.Microsoft3DViewer",
"Microsoft.MicrosoftEdge.Stable",
"Microsoft.MicrosoftOfficeHub",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.MicrosoftStickyNotes",
"Microsoft.Services.Store.Engagement",
"Microsoft.MixedReality.Portal",
"Microsoft.MSPaint",
"Microsoft.Office.OneNote",
"Microsoft.People",
"Microsoft.ScreenSketch",
"Microsoft.StorePurchaseApp",
"Microsoft.VP9VideoExtensions",
"Microsoft.Wallet",
"Microsoft.WebMediaExtensions",
"Microsoft.Windows.Photos",
"Microsoft.WebpImageExtension",
"Microsoft.WindowsCalculator",
"Microsoft.WindowsCamera",
"Microsoft.WindowsFeedbackHub",
"Microsoft.WindowsMaps",
"Microsoft.WindowsSoundRecorder",
"Microsoft.WindowsStore",
"Microsoft.Xbox",
"Microsoft.XboxApp",
"Microsoft.XboxGameOverlay",
"Microsoft.XboxGamingOverlay",
"Microsoft.XboxIdentityProvider",
"Microsoft.XboxSpeechToTextOverlay",
"Microsoft.YourPhone",
"Microsoft.ZuneMusic",
"Microsoft.ZuneVideo"
)

	#REMOVE ALL USER SPECIFIC APPS
$all = Get-AppxPackage -Allusers
$usr = Get-AppxPackage -user "Administrator" | where-object {$exclude = $false; foreach ($app in $all){if ($_.Name -like $app.Name){$exclude = $true;break}}return -not $exclude}

foreach ($app in $usr) { try { remove-appxpackage $app } catch { write-output "skipping" } }

	# REMOVE ALL OTHER APPS
$apps = $all | where-object {$exclude = $false; foreach ($name in $whitelist){if ($_.InstallLocation -like "*$($name)*"){$exclude = $true;break}}return -not $exclude}

foreach ($app in $apps) { $usrinpt = Read-Host "Do you want to remove $($app.Name)? (type 'y' to remove)"; if ($usrinpt -ne "y") { continue }; try { remove-appxpackage $app; write-output "removed" } catch { write-output "skipping" } }

	# pre-remove packages removed by sysprep
$os = systeminfo /fo csv | ConvertFrom-Csv | select "OS Name"
if ($os -like "*10*") { foreach ($name in $win10) { try { get-appxpackage -name $name | remove-appxpackage } catch {} } } elseif ($os -like "*11*") {}

	# VERIFY FILE INTEGRITY
clear
sfc /scannow

	#TURN OFF BITLOCKER
$vols = get-bitlockervolume
$decrypt = $false
foreach ($vol in $vols)
{
 if ($vol.EncryptionPercentage -gt 0)
 {
  manage-bde -off $vol.mountpoint
  $decrypt = $true
 }
}

$dots = 1
while ($decrypt)
{
 $vols = get-bitlockervolume
 $decrypt = $false
 foreach ($vol in $vols)
 {
  if ($vol.EncryptionPercentage -gt 0)
  {
   $out = "`r Decrypting drive $($vol.mountpoint): $($vol.encryptionpercentage)% encrypted"
   for ($i = 0; $i -lt $dots; $i++)
   {
    $out = $out + "."
   }
   write-host "$($out)        " -nonewline
   $decrypt = $true
   break
  }
 }
 $dots++
 if ($dots -gt 3) 
 {
  $dots = 1
 }
 start-sleep 2
}

	#RESET EXECUTION POLICY
set-executionpolicy default

	#START SYSPREP
clear;
$usrInpt = Read-Host "Start sysprep? (type 'y' to start)";
if ($usrInpt -eq "y") { c:/windows/system32/sysprep/sysprep /oobe /generalize /shutdown }