function migration_0_4_1()
	entities_migration_V2()
	local hc = global.hardCrafting
	hc.entityData = nil
	hc.playerData = nil
	hc.schedule = nil
	
	global.entities_cleanup_required = true
	global.gui = nil
	global.itemSelection = nil
	
	hc.version = "0.4.1"
end