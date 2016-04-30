require "control.AccessFactory"

knownEntities["belt-sorter"] = true
knownEntities["fast-belt-sorter"] = true

---------------------------------------------------
-- init
---------------------------------------------------

function beltSorterInit()
	if not global.hardCrafting.beltSorter then	
		global.hardCrafting.beltSorter = {}
	end
	if not global.hardCrafting.fbeltSorter then
		global.hardCrafting.fbeltSorter = {}
	end
end

function beltSorterBuiltEntity(entity)
	table.insert(global.hardCrafting.beltSorter, entity)
end
function fastBeltSorterBuilt(entity)
	table.insert(global.hardCrafting.fbeltSorter, entity)
end

---------------------------------------------------
-- update tick
---------------------------------------------------
local searchPriority = {{0,-1},{-1,0},{1,0},{0,1}}

function updateBeltSorter(event)
	-- update every 10 ticks
	if game.tick % 5 ~= 0 then return end
	for k,beltSorter in pairs(global.hardCrafting.fbeltSorter) do
		if not beltSorter.valid then
			global.hardCrafting.fbeltSorter[k] = nil
		else
			updateNormalBeltSorter(beltSorter)
		end
	end

	if game.tick % 10 ~= 0 then return end
	for k,beltSorter in pairs(global.hardCrafting.beltSorter) do
		if not beltSorter.valid then
			global.hardCrafting.beltSorter[k] = nil
		else
			updateNormalBeltSorter(beltSorter)
		end
	end
end

function updateNormalBeltSorter(beltSorter)
	local surface = beltSorter.surface
	local x = beltSorter.position.x
	local y = beltSorter.position.y
	--info("updating belt: "..x..","..y)
	-- search for input / output belts
	local input = {} -- BeltAccess / SplitterAccess objects
	local output = {} -- BeltAccess / SplitterAccess objects
	--info("searching for belts...")
	local searchTypes = BeltFactory.getSupportedTypes()
	for _,searchPos in pairs(searchPriority) do
		local searchPoint = { x = x + searchPos[1], y = y + searchPos[2] }
		for _,searchType in pairs(searchTypes) do
			local candidates = surface.find_entities_filtered{area = {searchPoint, searchPoint}, type= searchType}
			for _,entity in pairs(candidates) do
				local access = BeltFactory.accessFor(entity,searchPoint,beltSorter.position)
				if access.isInput() then
					table.insert(input,access)
				else
					table.insert(output,access)
				end
			end
		end
	end
	
	-- Build filter table from inventory
	local filter = {} -- {direction = {itemName, ..}}
	local slotIndexToDirection = {[0]=defines.direction.north, [1]=defines.direction.west,
																[2]=defines.direction.east, [3]=defines.direction.south}
	local inventory = beltSorter.get_inventory(defines.inventory.chest)
	for i = 1,40 do
		if inventory[i]~=nil and inventory[i].valid_for_read then
			local slotRow = slotIndexToDirection[math.floor((i-1)/10)]
			if filter[slotRow] == nil then filter[slotRow]={} end
			table.insert(filter[slotRow],inventory[i].name)
		end
	end
	
	-- Distribute items on output belts
	for _,outputAccess in pairs(output) do
		local beltSide = outputAccess.getSide()
		if outputAccess.can_insert_at_back() and filter[beltSide] then
			local canInsert = true
			for _,itemName in pairs(filter[beltSide]) do
				for _,inputAccess in pairs(input) do
					if not inputAccess then warn(input) end

					if inputAccess.contains_item(itemName) then
						local itemStack = {name=itemName,count=1}
						local result = inputAccess.remove_item(itemStack)
						if result>0 then
							outputAccess.insert_at_back(itemStack)
							canInsert = outputAccess.can_insert_at_back()
						end
					end
					if not canInsert then break end
				end
				if not canInsert then break end
			end
		end
	end
end
