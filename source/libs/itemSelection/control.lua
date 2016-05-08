
-- call this to open the item selection gui
-- player: LuaPlayer
-- method: function(itemName) callback which is executed when an item has been selected

itemSelection_open = function(player,method)
	if player.gui.left.itemSelection ~= nil then
		itemSelection_close(player)
	end
	local frame = player.gui.left.add{type="frame",name="itemSelection",direction="vertical",caption={"item-selection"}}

	frame.add{type="table",name="recent",colspan=11}
	frame.recent.add{type="label",name="title",caption={"",{"recent"},":"}}

	frame.add{type="table",name="search",colspan=2}
	frame.search.add{type="label",name="title",caption={"",{"search"},":"}}

	frame.add{type="table",name="items",colspan=20}

	local index = 1
	for name,prototype in pairs(game.item_prototypes) do
		frame.items.add({
			type = "checkbox",
			name = "itemSelection."..name,
			style = "item-"..name,
			state = true   -- this is important, it makes our graphic, which is the "check mark", display
		})
		index = index + 1
		if index > 80 then break end
	end
	
	-- Store reference for callback
	if global.itemSelection == nil then global.itemSelection = {} end
	if global.itemSelection[player.name] == nil then global.itemSelection[player.name] = {} end
	global.itemSelection[player.name].callback = method
end

itemSelection_gui_click = function(guiEvent,player)
	local itemName = guiEvent[1]
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
