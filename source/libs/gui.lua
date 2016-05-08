-- API
-- modName - prefix which your ui components have. e.g. "hc.belt-sorter.1.1" (modName = "hc")

-- each known gui defines these functions:
gui = {} -- [$entityName] = { open = $function(player,entity), close = $function(player),
-- click = $function(nameArr, player) }


script.on_event(defines.events.on_gui_click, function(event)
	info(event)
	if event.element.style and event.element.style.name then
		if event.element.style.name:starts("item-") then
			event.element.state = true
		end
	end
	local guiEvent = split(event.element.name,".")
	local eventIsForMod = table.remove(guiEvent,1)
	local player = game.players[event.player_index]
	if eventIsForMod == "itemSelection" then
		itemSelection_gui_click(guiEvent,player)
	elseif eventIsForMod == modName then
		local entityName = table.remove(guiEvent,1)
		if entityName and gui[entityName] then
			if gui[entityName].click ~= nil then
				gui[entityName].click(guiEvent,player)
			end
		end
	end
end)


function initGui()
	if global.gui == nil then global.gui = {playerData = {}} end
end

function tickGui()
	if game.tick % 10 ~= 0 then return end
	for _,player in pairs(game.players) do
		if player.connected then
			local openEntity = player.opened
			local playerName = player.name
			if global.gui.playerData[playerName] == nil then global.gui.playerData[playerName] = {} end
			local playerData = global.gui.playerData[playerName]
			local openGui = playerData.openGui
			if openEntity == nil then
				if openGui ~= nil then
					if gui[openGui] ~= nil and gui[openGui].close ~= nil then
						gui[openGui].close(player)
					end
					playerData.openGui = nil
				end
			elseif openGui == nil then
				openGui = openEntity.name
				playerData.openGui = openGui
				if gui[openGui] ~= nil and gui[openGui].open ~= nil then
					gui[openGui].open(player,openEntity)
				end
			end
		end
	end
end
