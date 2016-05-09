require "libs.classes.BeltFactory"
require "libs.itemSelection.control"

-- Registering entity into system
local beltSorter = {}
entities["belt-sorter-v2"] = beltSorter

-- Constants
local searchPriority = {{0,-1},{-1,0},{1,0},{0,1}}
local rowIndexToDirection = {
	[1]=defines.direction.north,
	[2]=defines.direction.west,
	[3]=defines.direction.east,
	[4]=defines.direction.south
}

---------------------------------------------------
-- entityData
---------------------------------------------------

-- Used data:
-- {
--   lamp = LuaEntity(fake lamp)
--   filter[$itemName] = { $row1, $row2, ... }
--   guiFilter[$row.."."..$slot] = $itemName
-- }

---------------------------------------------------
-- build and remove
---------------------------------------------------

beltSorter.build = function(entity)
	scheduleAdd(entity, (game or {tick=TICK_ASAP}).tick)

	local pos = {x = entity.position.x-0.25, y=entity.position.y}
	local lamp = entity.surface.create_entity({name="belt-sorter-lamp",position=pos,force=entity.force})
	lamp.operable = false
	lamp.minable = false
	lamp.destructible = false

	entity.connect_neighbour{wire=defines.circuitconnector.green,target_entity=lamp}

	return {
		lamp = lamp,
		filter = {}
	}
end

beltSorter.remove = function(data)
	data.lamp.destroy()
end

---------------------------------------------------
-- gui actions
---------------------------------------------------

gui["belt-sorter-v2"]={}
gui["belt-sorter-v2"].open = function(player,entity)
	local frame = player.gui.left.add{type="frame",name="beltSorterGui",direction="vertical",caption={"belt-sorter-title"}}
	frame.add{type="table",name="table",colspan=5}

	local labels={"north","west","east","south"}
	for i,label in pairs(labels) do
		frame.table.add{type="label",name="title"..i,caption={"",{label},":"}}
		for j=1,4 do
			frame.table.add{type="checkbox",name="hc.slot."..i.."."..j,state=true,style="item-empty"}
		end
	end
	beltSorterRefreshGui(player,entity)
end

gui["belt-sorter-v2"].close = function(player)
	player.gui.left.beltSorterGui.destroy()
	itemSelection_close(player)
end

gui["belt-sorter-v2"].click = function(nameArr,player,entity)
	local fieldName = table.remove(nameArr,1)
	if fieldName == "slot" then
		local box = player.gui.left.beltSorterGui.table["hc.slot."..nameArr[1].."."..nameArr[2]]
		if box.style.name == "item-empty" then
			itemSelection_open(player,function(itemName)
				box.style="item-"..itemName
				beltSorterSetSlotFilter(entity,nameArr,itemName)
			end)
		else
			box.style = "item-empty"
			beltSorterSetSlotFilter(entity,nameArr,nil)
		end
	elseif fieldName == "copy" then
		
	elseif fieldName == "paste" then
	
	end
end

function beltSorterRefreshGui(player,entity)
	local data = global.entityData[idOfEntity(entity)]
	if data.guiFilter == nil then return end
	for row = 1,4 do
		for slot = 1,4 do
			local itemName = data.guiFilter[row.."."..slot]
			local element = player.gui.left.beltSorterGui.table["hc.slot."..row.."."..slot]
			if itemName then
				element.style = "item-"..itemName
			else
				element.style = "item-empty"
			end
		end
	end 
end

function beltSorterSetSlotFilter(entity,nameArr,itemName)
	local data = global.entityData[idOfEntity(entity)]
	if data.guiFilter == nil then data.guiFilter = {} end
	data.guiFilter[nameArr[1].."."..nameArr[2]] = itemName
	beltSorterRebuildFilterFromGui(data)
end

function beltSorterRebuildFilterFromGui(data)
	data.filter = {}
	for row = 1,4 do
		for slot = 1,4 do
			local itemName = data.guiFilter[row.."."..slot]
			if itemName then
				if data.filter[itemName] == nil then data.filter[itemName] = {} end
				table.insert(data.filter[itemName],row)
			end
		end
	end
end

---------------------------------------------------
-- update tick
---------------------------------------------------

beltSorter.tick = function(beltSorter,data)
	beltSorterSearchInputOutput(beltSorter,data)
	beltSorterDistributeItems(beltSorter,data)
	return 8,nil
end

function beltSorterDistributeItems(beltSorter,data)
	-- Search for input (only loop if items available), mostly only 1 input
	for _,inputAccess in pairs(data.input) do
		for itemName,_ in pairs(inputAccess.get_contents()) do
			local sideList = data.filter[itemName]
			if sideList then
				for _,side in pairs(sideList) do
					local outputAccess = data.output[side]
					if outputAccess then
						local itemStack = {name=itemName,count=1}
						local result = inputAccess.remove_item(itemStack)
						if result>0 then
							outputAccess.insert_at_back(itemStack)
							outputAccess.can_insert_at_back()
						else
							break -- check other items
						end
					end
				end
			end
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
	data.output = {} -- [side]=>$entity  BeltAccess / SplitterAccess objects
	--info("searching for belts...")
	for rowIndex,searchPos in pairs(searchPriority) do
		local searchPoint = { x = x + searchPos[1], y = y + searchPos[2] }
		for _,searchType in pairs(BeltFactory.supportedTypes) do
			local candidates = surface.find_entities_filtered{area = {searchPoint, searchPoint}, type= searchType}
			for _,entity in pairs(candidates) do
				local access = BeltFactory.accessFor(entity,searchPoint,beltSorter.position)
				if access.isInput() then
					table.insert(data.input,access)
				else
					data.output[rowIndex] = access
				end
			end
		end
	end
end
