Prepares the system for a sysprep

-Deletes any packages installed only for admin
-Checks for any apps installed that aren't in the whitelist and prompts the user whether to delete them
-If run on windows 10, remove all apps that would be removed by sysprep to prevent infinite sysprep bug
-Runs an sfc /scannow
-Disables bitlocker (if on)
-Prompts the user whether to start a generalize sysprep