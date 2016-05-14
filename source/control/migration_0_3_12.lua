
function migration_0_3_12()
	global.entities_cleanup_required = true
	global.hardCrafting.version = "0.3.12"
	info("Migration done to 0.3.12")
end