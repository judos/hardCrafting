
-- Constants:
local guiUpdateEveryTicks = 5

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

-- Required Calls from control.lua:
-- gui_tick()
-- gui_init()

-- Helper functions:
-- gui_playersWithOpenGuiOf(entity) : {x:LuaPlayer, ...}
-- gui_scheduleEvent($uiComponentIdentifier,$player)

--------------------------------------------------
-- Global data
--------------------------------------------------

-- This helper file uses the following global data variables:
-- global.gui.playerData[$playerName].openGui = $(name of opened entity)
--                                   .openEntity = $(reference of LuaEntity)
--     "      events[$tick] = { {$uiComponentIdentifier, $player}, ... }
--     "      version = $number

--------------------------------------------------
-- Implementation
--------------------------------------------------


function gui_init()
	if global.gui == nil then
		global.gui = {
			playerData = {},
			events = {},
			version = 1
		}
	end
	local prevGui = global.gui.version
	if not global.gui.version then
		global.gui.version = 1
		global.itemSelection = nil
	end
	if global.gui.version ~= prevGui then
		info("Migrated gui version to "..tostring(global.gui.version))
	end
end

local function handleEvent(uiComponentIdentifier,player)
	local guiEvent = split(uiComponentIdentifier,".")
	local eventIsForMod = table.remove(guiEvent,1)
	if eventIsForMod == modName then
		local entityName = global.gui.playerData[player.name].openGui
		if entityName and gui[entityName] then
			if gui[entityName].click ~= nil then
				local entity = global.gui.playerData[player.name].openEntity
				gui[entityName].click(guiEvent,player,entity)
			end
		elseif entityName == nil then
			warn("No entityName found for player "..player.name)
			warn(global.gui.playerData[player.name])
		else
			warn("No gui registered for "..entityName)
		end
		return true
	else
		-- gui event might be from other mods
		info("unknown gui event occured: "..serpent.block(uiComponentIdentifier)..". If this component belongs to your mod it should contain \"$modName.\" as the beginning of the component name.")
	end
end

function gui_scheduleEvent(uiComponentIdentifier,player)
	global.gui.events = global.gui.events or {}
	table.insert(global.gui.events,{uiComponentIdentifier=uiComponentIdentifier,player=player})
end

local function playerCloseGui(player,playerData,openGui)
	if gui[openGui] ~= nil and gui[openGui].close ~= nil then
		gui[openGui].close(player)
	end
	playerData.openGui = nil
	playerData.openEntity = nil
end

local function playerOpenGui(player,playerData,openEntity)
	local openGui = openEntity.name
	playerData.openGui = openGui
	playerData.openEntity = openEntity
	if gui[openGui] ~= nil and gui[openGui].open ~= nil then
		gui[openGui].open(player,openEntity)
	end
end

function gui_tick()
	if game.tick % guiUpdateEveryTicks ~= 0 then return end
	if global.gui.events ~= nil then
		local events = global.gui.events
		global.gui.events = nil
		if #events > 0 then
			for _,event in pairs(events) do
				handleEvent(event.uiComponentIdentifier, event.player)
			end
		end
	end
	for _,player in pairs(game.players) do
		if player.connected then
			local openEntity = player.opened
			local playerName = player.name
			if global.gui.playerData[playerName] == nil then global.gui.playerData[playerName] = {} end
			local playerData = global.gui.playerData[playerName]
			local openGui = playerData.openGui
			if openGui ~= nil and playerData.openEntity ~= openEntity then
				playerCloseGui(player,playerData,openGui)
			end
			if openGui == nil and openEntity ~= nil then
				playerOpenGui(player,playerData,openEntity)
			end
		end
	end
end


--------------------------------------------------
-- Event registration
--------------------------------------------------

local function handleGuiEvent(event)
	local player = game.players[event.player_index]
	local uiComponentIdentifier = event.element.name
	return handleEvent(uiComponentIdentifier,player)
end

script.on_event(defines.events.on_gui_click,handleGuiEvent)
script.on_event(defines.events.on_gui_text_changed,handleGuiEvent)
script.on_event(defines.events.on_gui_elem_changed,handleGuiEvent)
script.on_event(defines.events.on_gui_checked_state_changed,handleGuiEvent)

--------------------------------------------------
-- Helper functions
--------------------------------------------------

function gui_playersWithOpenGuiOf(entity)
	local result = {}
	for _,player in pairs(game.players) do
		if player.connected then
			local openEntity = player.opened
			if openEntity == entity then
				table.insert(result,player)
			end
		end
	end
	return result
end
