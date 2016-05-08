
modVersion = "0.3.11"

require "defines"
require "libs.functions"
require "libs.controlFunctions"

require "libs.entities" --lets your classes register event functions in general
require "libs.gui" --lets you register functions when a entity gui is opened/closed

require "control.belt-sorter"
require "control.incinerators"
require "control.migration_0_3_11"


-- global data used:
-- hardCrafting.version = $version
-- hardCrafting.incinerators = { $incinerator:LuaEntity, ... }
-- hardCrafting.eincinerators = { $incinerator:LuaEntity, ... }
-- Currently only belt-sorters use generic entity system

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

	if hc.incinerators == nil then hc.incinerators = {} end
	if hc.eincinerators == nil then hc.eincinerators = {} end
	if hc.schedule == nil then hc.schedule = {} end
	if hc.entityData == nil then hc.entityData = {} end
	if hc.playerData == nil then hc.playerData = {} end
	info(hc.version)
	if hc.version < "0.3.11" then migration_0_3_11() end
	
	entities_init()
end

script.on_event(defines.events.on_gui_click, function(event)
	local element = event.element
	warn(element.name)
end)

script.on_event(defines.events.on_tick, function(event)
	tickGui()
	updateIncinerators()
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


