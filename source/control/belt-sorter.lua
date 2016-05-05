require "libs.classes.BeltFactory"

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
		if outputAccess.can_insert_at_back() then
			local canInsert = true
			for itemName,_ in pairs(data.filter[beltSide]) do
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

local rowIndexToDirection = {
	[1]=defines.direction.north,
	[2]=defines.direction.west,
	[3]=defines.direction.east,
	[4]=defines.direction.south
}
function beltSorterBuiltFilter(beltSorter,data)
	if data.filter == nil then data.filter = {} end
	-- Build filter table from inventory
	local itemsPerRow = {[1]={},[2]={},[3]={},[4]={}}
	local inventory = beltSorter.get_inventory(defines.inventory.chest)
	local row = 1
	local itemStack
	for i = 1,40 do
		itemStack = inventory[i]
		if itemStack ~= nil and itemStack.valid_for_read then
			itemsPerRow[row][itemStack.name]=true
		end
		if i%10 == 0 then
			row=row+1
		end
	end
	for i=1,4 do
		data.filter[rowIndexToDirection[i]] = itemsPerRow[i]
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
