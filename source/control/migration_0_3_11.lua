
function migration_0_3_11()

	-- Migrate global content from:
	-- hardCrafting.beltSorter = { $beltSorter:LuaEntity, ... }
	
	-- To
	-- Currently only belt-sorters use generic setup:
	-- hardCrafting.schedule[tick][idEntity] = $entity
	-- hardCrafting.entityData[idEntity] = { name=$name, ... }
	
	-- Spread all the belt-sorters among the next 8 ticks:
	local hc = global.hardCrafting
	
	for _,beltSorter in pairs(hc.beltSorter) do
		if beltSorter.valid then
			local data = entities["belt-sorter"].build(beltSorter)
			global.entityData[idOfEntity(beltSorter)] = { ["name"] = "belt-sorter" }
			table.addTable(global.entityData[idOfEntity(beltSorter)],data)
		end
	end
	hc.beltSorter = nil
	hc.version = "0.3.11"
end
