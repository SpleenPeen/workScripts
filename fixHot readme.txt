Fixes the brightness hotkeys not working on some HP models (only works on win11).
-Disabled device install prevention policy
-Uninstalls newer driver version
-Installs working driver version
-Reinstates the device install prevention policy (makes the user unable to install/remove the drivers for the hotkeys device)
-Adds this script and its dependencies to C:/windows/setup/scripts, to make sure the correct driver and policy setting are applied after sysprep and setup.