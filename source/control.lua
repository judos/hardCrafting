require "defines"
require "libs.functions"
require "libs.controlFunctions"

knownEntities = {}
require "control.belt-sorter"
require "control.incinerators"

modVersion = "0.3.11"

--[[
 Data:
 hardCrafting.version = $version
 hardCrafting.incinerators = { $incinerator:LuaEntity, ... }
 hardCrafting.eincinerators = { $incinerator:LuaEntity, ... }
 hardCrafting.beltSorter = { $beltSorter:LuaEntity, ... }
 hardCrafting.fbeltSorter = { $fastBeltSorter:LuaEntity, ... }
]]--

-- Init --
script.on_init(function()
	init()
end)

script.on_load(function()
	init()
end)

function init()
	if not global.hardCrafting then global.hardCrafting = {} end
	local hc = global.hardCrafting
	if not hc.version then hc.version = modVersion end
	if not hc.incinerators then hc.incinerators = {} end
	if not hc.eincinerators then hc.eincinerators = {} end
	beltSorterInit()
end

script.on_event(defines.events.on_tick, function(event)
	updateBeltSorter(event)
	updateIncinerators()
end)

---------------------------------------------------
-- Building Entities
---------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	entityBuilt(event)
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
	entityBuilt(event)
end)

function entityBuilt(event)
	local entity = event.created_entity
	if not knownEntities[entity.name] then return end
	if entity.name == "belt-sorter" then
		beltSorterBuiltEntity(entity)
	elseif entity.name == "fast-belt-sorter" then
		fastBeltSorterBuilt(entity)
	elseif entity.name == "incinerator" then
		table.insert(global.hardCrafting.incinerators,entity)
	elseif entity.name == "electric-incinerator" then
		table.insert(global.hardCrafting.eincinerators,entity)
	end
end
