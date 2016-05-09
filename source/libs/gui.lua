-- Constants:
local guiUpdateEveryTicks = 15

--------------------------------------------------
-- API
--------------------------------------------------

-- Requried:
-- modName - prefix which your ui components have. e.g. "hc.belt-sorter.1.1" (modName = "hc")

-- Usage:
-- each known gui defines these functions:
gui = {} -- [$entityName] = { open = $function(player,entity),
--                            close = $function(player),
--                            click = $function(nameArr, player, entity) }

-- gui_scheduleEvent($uiComponentIdentifier,$player)

--------------------------------------------------
-- Global data
--------------------------------------------------

-- This helper file uses the following global data variables:
-- global.gui.playerData[$playerName].openGui = $(name of opened entity)
--                                   .openEntity = $(reference of LuaEntity)
--            events[$tick] = { {$uiComponentIdentifier, $player}, ... }

--------------------------------------------------
-- Implementation
--------------------------------------------------

local function handleEvent(uiComponentIdentifier,player)
	local guiEvent = split(uiComponentIdentifier,".")
	local eventIsForMod = table.remove(guiEvent,1)
	if eventIsForMod == "itemSelection" then
		itemSelection_gui_event(guiEvent,player)
	elseif eventIsForMod == modName then
		local entityName = global.gui.playerData[player.name].openGui
		if entityName and gui[entityName] then
			if gui[entityName].click ~= nil then
				local entity = global.gui.playerData[player.name].openEntity
				gui[entityName].click(guiEvent,player,entity)
			end
		end
	end
end

function gui_scheduleEvent(uiComponentIdentifier,player)
	global.gui.events = {}
	table.insert(global.gui.events,{uiComponentIdentifier=uiComponentIdentifier,player=player})
end


function gui_init()
	if global.gui == nil then 
		global.gui = {
			playerData = {},
			events = {}
		}
	end
end

function gui_tick()
	if game.tick % guiUpdateEveryTicks ~= 0 then return end
	if global.gui.events ~= nil then
		if #global.gui.events > 0 then
			for _,event in pairs(global.gui.events) do
				handleEvent(event.uiComponentIdentifier, event.player)
			end
		end
		global.gui.event = {}
	end
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
					playerData.openEntity = nil
				end
			elseif openGui == nil then
				openGui = openEntity.name
				playerData.openGui = openGui
				playerData.openEntity = openEntity
				if gui[openGui] ~= nil and gui[openGui].open ~= nil then
					gui[openGui].open(player,openEntity)
				end
			end
		end
	end
end

--------------------------------------------------
-- Event registration
--------------------------------------------------

script.on_event(defines.events.on_gui_click, function(event)

		if event.element.style and event.element.style.name then
			if event.element.style.name:starts("item-") then
				event.element.state = true
			end
		end
		local player = game.players[event.player_index]
		local uiComponentIdentifier = event.element.name
		handleEvent(uiComponentIdentifier,player)
end)
