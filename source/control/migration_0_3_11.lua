require "defines"
require "libs.inventory"

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
			-- store important values
			local surface = beltSorter.surface
			local force = beltSorter.force
			local position = beltSorter.position
			
			-- spill out inventory of chest
			local filter = oldBeltSorterBuiltFilter(beltSorter)
			spillInventory(beltSorter.get_inventory(defines.inventory.chest), surface, position)
			beltSorter.destroy()
			
			-- create new entity and register it
			beltSorter = surface.create_entity({name="belt-sorter-v2",force=force,position=position})
			local data2 = entities["belt-sorter-v2"].build(beltSorter)
			local data = {
				name = "belt-sorter-v2",
				guiFilter = filter
			}
			table.addTable(data,data2)
			global.entityData[idOfEntity(beltSorter)] = data
			beltSorterRebuildFilterFromGui(data)
		end
	end
	hc.beltSorter = nil
	hc.version = "0.3.11"
	info("Migration done to 0.3.11")
end

local rowIndexToDirection = {
	[1]=defines.direction.north,
	[2]=defines.direction.west,
	[3]=defines.direction.east,
	[4]=defines.direction.south
}

function oldBeltSorterBuiltFilter(beltSorter)
	-- Build filter table from inventory
	local inventory = beltSorter.get_inventory(defines.inventory.chest)
	local row = 1
	local itemStack
	local filter = {}
	local slot = 1
	local itemError = ""
	for i = 1,40 do
		itemStack = inventory[i]
		if itemStack ~= nil and itemStack.valid_for_read then
			local itemName = itemStack.name
			if slot <= 4 then
				filter[row.."."..slot] = itemName
				slot = slot + 1
			else
				itemError = itemError..itemName..", "
			end
		end
		if i%10 == 0 then
			row = row + 1
			slot = 1
		end
	end
	if itemError ~= "" then
		err("Belt-sorter filter at "..beltSorter.position.x.."/"..beltSorter.position.y.." could not be migrated -> Please check filter for: "..itemError:sub(1,-2))
	end
	return filter
end