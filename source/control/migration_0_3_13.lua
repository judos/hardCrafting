
function migration_0_3_13()
	global.entities_cleanup_required = true
	global.hardCrafting.version = "0.3.13"
	info("Migration done to 0.3.13 - will do a schedule table cleanup")
end