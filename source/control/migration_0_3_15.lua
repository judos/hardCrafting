
function migration_0_3_15()
	entities_migration_V2()
	global.hardCrafting.schedule = nil
	global.hardCrafting.entityData = nil
	global.hardCrafting.playerData = nil
	global.hardCrafting.version = "0.3.15"
	info("Migration done to 0.3.15")
end
