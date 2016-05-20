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
--   nextSearchDir = $index (which direction to search next)
-- }

--------------------------------------------------
-- Global data
--------------------------------------------------

-- This helper file uses the following global data variables:
-- global.gui.playerData[$playerName].beltSorterGuiCopy = $guiFilter

---------------------------------------------------
-- build and remove
---------------------------------------------------

beltSorter.build = function(entity)
	scheduleAdd(entity, TICK_ASAP)

	local pos = {x = entity.position.x, y=entity.position.y}
	local lamp = entity.surface.create_entity({name="belt-sorter-lamp",position=pos,force=entity.force})
	lamp.operable = false
	lamp.minable = false
	lamp.destructible = false
	lamp.set_circuit_condition(defines.circuitconditionindex.lamp,
		{condition={comparator="=",
			first_signal={type="item", name="iron-plate"},
			second_signal={type="item", name="iron-plate"}}
		})

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
	frame.add{type="table",name="settings",colspan=2}
	frame.settings.add{type="button",name="hc.copy",caption={"copy"}}
	frame.settings.add{type="button",name="hc.paste",caption={"paste"}}
	beltSorterRefreshGui(player,entity)
end

gui["belt-sorter-v2"].close = function(player)
	if player.gui.left.beltSorterGui then
		player.gui.left.beltSorterGui.destroy()
	end
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
		if global.gui.playerData[player.name] == nil then global.gui.playerData[player.name] = {} end
		local data = global.entityData[idOfEntity(entity)]
		global.gui.playerData[player.name].beltSorterGuiCopy = deepcopy(data.guiFilter)
	elseif fieldName == "paste" then
		local playerData = global.gui.playerData[player.name]
		if playerData ~= nil and playerData.beltSorterGuiCopy ~= nil then
			local data = global.entityData[idOfEntity(entity)]
			data.guiFilter = playerData.beltSorterGuiCopy
			beltSorterRefreshGui(player,entity)
			beltSorterRebuildFilterFromGui(data)
		end
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
	if data.condition == nil or data.nextConditionUpdate == nil or data.nextConditionUpdate <= game.tick then
		beltSorterUpdateCircuitCondition(beltSorter,data)
		if data.condition == false then
			return 60,nil
		end
	end

	local energyPercentage = math.min(beltSorter.energy,800) / 800
	local nextUpdate = math.floor(8 / energyPercentage)
	if energyPercentage < 0.1 then
		nextUpdate = 80
	else
		beltSorterSearchInputOutput(beltSorter,data)
		beltSorterDistributeItems(beltSorter,data)
	end
	return nextUpdate,nil
end

function beltSorterUpdateCircuitCondition(beltSorter,data)
	local circuitCondition = beltSorter.get_circuit_condition(defines.circuitconditionindex.lamp)
	if circuitCondition.condition.first_signal.name ~= nil then
		data.condition = circuitCondition.fulfilled
	else
		data.condition = true
	end
	local lampCondition = {
		condition = {
			comparator= (data.condition and "=" or ">"),
			first_signal={type="item", name="iron-plate"},
			second_signal={type="item", name="iron-plate"}
		}
	}
	data.lamp.set_circuit_condition(defines.circuitconditionindex.lamp,lampCondition)
	data.nextConditionUpdate = game.tick + 60
end

function beltSorterDistributeItems(beltSorter,data)
	-- Search for input (only loop if items available), mostly only 1 input
	for inputSide,inputAccess in pairs(data.input) do
		if not inputAccess:isValid() then
			data.input[inputSide] = nil
		else
			for itemName,_ in pairs(inputAccess:get_contents()) do
				local sideList = data.filter[itemName]
				if sideList then
					for _,side in pairs(sideList) do
						local outputAccess = data.output[side]
						if outputAccess then
							if not outputAccess:isValid() then
								data.output[side] = nil
							else
								if outputAccess:can_insert_at_back() then
									local itemStack = {name=itemName,count=1}
									local result = inputAccess:remove_item(itemStack)
									if result>0 then
										outputAccess:insert_at_back(itemStack)
									else
										break -- check other items
									end
								end
							end
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
	-- search for input / output belts
	data.input = {}
	data.output = {}
	for rowIndex = 1, 4 do
		data.input[rowIndex] = nil -- [side] => BeltAccess / SplitterAccess objects
		data.output[rowIndex] = nil -- [side] => BeltAccess / SplitterAccess objects
		local searchPos = searchPriority[rowIndex]
		local searchPoint = { x = x + searchPos[1], y = y + searchPos[2] }
		for _,searchType in pairs(BeltFactory.supportedTypes) do
			local candidates = surface.find_entities_filtered{area = {searchPoint, searchPoint}, type= searchType}
			for _,entity in pairs(candidates) do
				local access = BeltFactory.accessFor(entity,searchPoint,beltSorter.position)
				if access:isInput() then
					data.input[rowIndex] = access
				else
					data.output[rowIndex] = access
				end
			end
		end
	end
	data.nextSearchDir = nil
end
