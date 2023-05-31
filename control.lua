require "libs.all"
require "constants"
require "libs.control.entities"

require "control.incinerators"
require "control.migration_0_4_1"

local railloader = require "interfaces.railloader"

-- global data used:
-- hardCrafting.version = $version
-- hardCrafting.incinerators = { $incinerator:LuaEntity, ... }
-- hardCrafting.eincinerators = { $incinerator:LuaEntity, ... }

if railloader.IsValid() then
	railloader.AddBulkItem("gravel")
end

-- Init --
script.on_init(function()
	init()
end)

script.on_load(function()
	if railloader.IsValid() then
		railloader.AddBulkItem("dirt")

		railloader.AddBulkItem("gravel")
		railloader.AddBulkItem("gravel-pile")

		railloader.AddBulkItem("coal-dust")

		railloader.AddBulkItem("iron-slag")
		railloader.AddBulkItem("iron-nugget")
		railloader.AddBulkItem("iron-nugget")
		railloader.AddBulkItem("crushed-iron")
		railloader.AddBulkItem("pulverized-iron")

		railloader.AddBulkItem("steel-dust")

		railloader.AddBulkItem("copper-sludge")
		railloader.AddBulkItem("copper-dust")
		railloader.AddBulkItem("sufur-dust")
		railloader.AddBulkItem("copper-sulfat")
	end
end)

script.on_configuration_changed(function()
	local hc = global.hardCrafting
	local previousVersion = hc.version
	if hc.version < "0.4.1" then migration_0_4_1() end
	if hc.version ~= previousVersion then
		info("Previous global data version: "..previousVersion)
		info("Migrated to version "..hc.version)
	end
end)

function init()
	if not global.hardCrafting then global.hardCrafting = {} end
	local hc = global.hardCrafting
	if not hc.version then hc.version = modVersion end

	if hc.incinerators == nil then hc.incinerators = {} end
	if hc.eincinerators == nil then hc.eincinerators = {} end

	entities_init()
	info("global after init: "..serpent.block(global))
end

script.on_event(defines.events.on_tick, function(event)
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


