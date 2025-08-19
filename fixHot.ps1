pnputil /delete-driver oem42.inf /uninstall /force
pnputil /delete-driver oem43.inf /uninstall /force
pnputil /delete-driver oem45.inf /uninstall /force

$driver = $PSScriptRoot + "/Driver/HpqKbSoftwareCompnent.inf"
pnputil /add-driver $driver /install