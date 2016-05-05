require "control.BeltFactory"

knownEntities["belt-sorter"] = true
knownEntities["fast-belt-sorter"] = true

---------------------------------------------------
-- init
---------------------------------------------------

function beltSorterWasBuilt(entity)
	scheduleAdd(entity, (game or {tick=TICK_ASAP}).tick)
end

---------------------------------------------------
-- update tick
---------------------------------------------------
local searchPriority = {{0,-1},{-1,0},{1,0},{0,1}}

function beltSorterDidTick(beltSorter,data)
	beltSorterSearchInputOutput(beltSorter,data)
	beltSorterBuiltFilter(beltSorter,data)
	beltSorterDistributeItems(beltSorter,data)
	return 8,nil
end

function beltSorterDistributeItems(beltSorter,data)
	-- Distribute items on output belts
	for _,outputAccess in pairs(data.output) do
		local beltSide = outputAccess.getSide()
		if outputAccess.can_insert_at_back() and data.filter[beltSide] then
			local canInsert = true
			for _,itemName in pairs(data.filter[beltSide]) do
				for _,inputAccess in pairs(data.input) do

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

function beltSorterBuiltFilter(beltSorter,data)
	-- Build filter table from inventory
	data.filter = {} -- {direction = {itemName, ..}}
	local slotIndexToDirection = {[0]=defines.direction.north, [1]=defines.direction.west,
																[2]=defines.direction.east, [3]=defines.direction.south}
	local inventory = beltSorter.get_inventory(defines.inventory.chest)
	for i = 1,40 do
		if inventory[i]~=nil and inventory[i].valid_for_read then
			local slotRow = slotIndexToDirection[math.floor((i-1)/10)]
			if data.filter[slotRow] == nil then data.filter[slotRow]={} end
			table.insert(data.filter[slotRow],inventory[i].name)
		end
	end
end

function beltSorterSearchInputOutput(beltSorter,data)
	local surface = beltSorter.surface
	local x = beltSorter.position.x
	local y = beltSorter.position.y
	--info("updating belt: "..x..","..y)
	-- search for input / output belts
	data.input = {} -- BeltAccess / SplitterAccess objects
	data.output = {} -- BeltAccess / SplitterAccess objects
	--info("searching for belts...")
	for _,searchPos in pairs(searchPriority) do
		local searchPoint = { x = x + searchPos[1], y = y + searchPos[2] }
		for _,searchType in pairs(BeltFactory.supportedTypes) do
			local candidates = surface.find_entities_filtered{area = {searchPoint, searchPoint}, type= searchType}
			for _,entity in pairs(candidates) do
				local access = BeltFactory.accessFor(entity,searchPoint,beltSorter.position)
				if access.isInput() then
					table.insert(data.input,access)
				else
					table.insert(data.output,access)
				end
			end
		end
	end
end