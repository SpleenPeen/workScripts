	# DELETE SEARCH FOLDER
$sFolder = "C:/Users/Administrator/AppData/Local/Packages/Microsoft.Windows.Search_cw5n1h2txyewy"
if(test-path -path $sFolder) {get-childitem $sFolder -recurse -force | remove-item -recurse -force; remove-item $sFolder -recurse -force}

	# DELETE SEARCH KEY
$sKey = "HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Search"
if(test-path -path $sKey) {remove-item -path $sKey -recurse -force}

	# DOWNLOAD SEARCH PACKAGE
add-appxpackage "C:/Windows/SystemApps/Microsoft.Windows.Search_cw5n1h2txyewy/Appxmanifest.xml" -DisableDevelopmentMode -Register

	# REBOOT
restart-computer