require "constants"
require "libs.functions"
require "libs.controlFunctions"

require "libs.entities" --lets your classes register event functions in general
require "libs.gui" --lets you register functions when a entity gui is opened/closed

require "control.incinerators"

-- global data used:
-- hardCrafting.version = $version
-- hardCrafting.incinerators = { $incinerator:LuaEntity, ... }
-- hardCrafting.eincinerators = { $incinerator:LuaEntity, ... }

-- Init --
script.on_init(function()
	init()
end)

function init()

	if not global.hardCrafting then global.hardCrafting = {} end
	local hc = global.hardCrafting
	if not hc.version then hc.version = modVersion end

	if hc.incinerators == nil then hc.incinerators = {} end
	if hc.eincinerators == nil then hc.eincinerators = {} end
	info("Previous global data version: "..hc.version)
	
	gui_init()
	entities_init()
	log("global before migration: "..serpent.block(global))
end

script.on_event(defines.events.on_tick, function(event)
	updateIncinerators()
	gui_tick()
	entities_tick()
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
	entities_build(event)
end


