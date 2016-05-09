local maxRecentEntries = 20
local mainMaxRows = 5
local mainMaxEntries = 30
-- call this to open the item selection gui
-- player: LuaPlayer
-- method: function(itemName) callback which is executed when an item has been selected

------------------------------------
-- Helper methods
------------------------------------

local function initGuiForPlayerName(playerName)
	if global.itemSelection == nil then global.itemSelection = {} end
	local is = global.itemSelection
	if is[playerName] == nil then is[playerName] = {} end
	if is[playerName].recent == nil then is[playerName].recent = {} end
end

local function checkBoxForItem(itemName)
	return {
		type = "checkbox",
		name = "itemSelection."..itemName,
		style = "item-"..itemName,
		state = true   -- this is important, it makes our graphic, which is the "check mark", display
	}
end

------------------------------------
-- Events
------------------------------------


itemSelection_open = function(player,method)
	initGuiForPlayerName(player.name)
	local playerData = global.itemSelection[player.name]

	if player.gui.left.itemSelection ~= nil then
		itemSelection_close(player)
	end

	local frame = player.gui.left.add{type="frame",name="itemSelection",direction="vertical",caption={"item-selection"}}
	frame.add{type="table",name="main",colspan=1}
	frame = frame.main

	if #playerData.recent > 0 then
		frame.add{type="table",name="recent",colspan=2}
		frame.recent.add{type="label",name="title",caption={"",{"recent"},":"}}
		frame.recent.add{type="table",name="items",colspan=#playerData.recent,style="table-no-border"}
		for _,itemName in pairs(playerData.recent) do
			frame.recent.items.add(checkBoxForItem(itemName))
		end
	end
	
	frame.add{type="table",name="search",colspan=2}
	frame.search.add{type="label",name="title",caption={"",{"search"},":"}}
	frame.search.add{type="textfield",name="field"}

	frame.add{type="table",name="items",colspan=mainMaxEntries,style="table-no-border"}

	local index = 1
	for name,prototype in pairs(game.item_prototypes) do
		frame.items.add(checkBoxForItem(name))
		index = index + 1
		if index > mainMaxRows*mainMaxEntries then break end
	end

	-- Store reference for callback

	global.itemSelection[player.name].callback = method
end

itemSelection_gui_click = function(guiEvent,player)
	local itemName = guiEvent[1]
	
	local playerData = global.itemSelection[player.name]
	table.insert(playerData.recent,1,itemName)
	for i=#playerData.recent,2,-1 do
		if playerData.recent[i] == itemName then playerData.recent[i] = nil end
	end
	if #playerData.recent > maxRecentEntries then
		table.remove(playerData.recent,maxRecentEntries)
	end
	
	if global.itemSelection[player.name].callback then
		global.itemSelection[player.name].callback(itemName)
		global.itemSelection[player.name].callback = nil
	end
	itemSelection_close(player)
end

itemSelection_close = function(player)
	if player.gui.left.itemSelection ~= nil then
		player.gui.left.itemSelection.destroy()
	end
end
