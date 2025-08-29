- serial.ps1 - displays machines serial number
- searchwin10.ps1 - fixes the broken start menu searchbar on windows 10
- prep.ps1 - prepares machine for a sys prep
- fixHot - some HP laptops have a 'HP Hotkey service' driver which breaks the brightness buttons when updated. This script installs the correct driver version and blocks 
         the device from installing/uninstalling the driver (through group policy change). It requires the Driver folder and setupcomplete.cmd to be in the same directory 
         as the script to function (it dumps the script and dependencies into C:/windows/setup/scripts, to make sure the hotkey service works after sysprep generalize).
