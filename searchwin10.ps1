	# DELETE SEARCH FOLDER
$sFolder = "C:/Users/Administrator/AppData/Local/Packages/Microsoft.Windows.Search_cw5n1h2txyewy"
if(test-path -path $sFolder) {remove-item -path $sFolder -recurse -force}

	# DELETE SEARCH KEY
$sKey = "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Search"
if(test-path -path $sKey) {remove-item -path $sKey -recurse -force}

	# DOWNLOAD SEARCH PACKAGE
add-appxpackage "C:/Windows/SystemApps/Microsoft.Windows.Search_cw5n1h2txyewy/Appxmanifest.xml" -DisableDevelopmentMode -Register

	# RESET POLICY
set-executionpolicy default

	# REBOOT
restart-computer