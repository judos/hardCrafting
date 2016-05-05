
modVersion = "0.3.11"

-- Tables used for registering common events of entities
-- [$entityName] = { build = $function(entity), tick = $function(entity,data), remove = $function(data) }
entities = {}
-- each known gui defines these functions:
gui = {} -- [$entityName] = { open = $function, close = $function }

require "defines"
require "libs.functions"
require "libs.controlFunctions"


require "control.belt-sorter"
require "control.incinerators"
require "control.migration_0_3_11"


-- global data used:
-- hardCrafting.version = $version
-- hardCrafting.incinerators = { $incinerator:LuaEntity, ... }
-- hardCrafting.eincinerators = { $incinerator:LuaEntity, ... }

-- Currently only belt-sorters use generic setup:
-- hardCrafting.schedule[tick][idEntity] = $entity
-- hardCrafting.entityData[idEntity] = { name=$name, ... }

-- Constants:
TICK_ASAP = 0 --game.tick used in migration when game variable is not available yet

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

	if hc.version < "0.3.11" then migration_0_3_11() end
end


script.on_event(defines.events.on_tick, function(event)
	updatePlayerGui()
	local hc = global.hardCrafting
	updateIncinerators()

	-- schedule events from migration
	if hc.schedule[TICK_ASAP] ~= nil then
		for id,entity in pairs(hc.schedule[TICK_ASAP]) do
			scheduleAdd(entity, game.tick )-- TODO: use randomized distribution math.random(8))
		end
		hc.schedule[TICK_ASAP] = nil
	end

	-- if no updates are scheduled return
	if hc.schedule[game.tick] == nil then
		return
	end
	--dummyUpdate()
	-- --[[
	-- Execute all scheduled events
	for entityId,entity in pairs(hc.schedule[game.tick]) do
		if entity and entity.valid then
			local data = hc.entityData[idOfEntity(entity)]
			local name = entity.name
			local nextUpdateInXTicks, reasonMessage
			if entities[name] ~= nil then
				if entities[name].tick ~= nil then
					nextUpdateInXTicks, reasonMessage = entities[name].tick(entity,data)
				end
			else
				warn("updating entity with unknown name: "..name)
			end
			if reasonMessage then
				info(name.." at " .. entity.position.x .. ", " ..entity.position.y .. ": "..reasonMessage)
			end
			if nextUpdateInXTicks then
				scheduleAdd(entity, game.tick + nextUpdateInXTicks)
				-- if no more update is scheduled, remove it from memory
				-- nothing to be done here, the entity will just not be scheduled anymore
			end
		elseif entityId == "text" then
			PlayerPrint(entity)
		else
			-- if entity was removed, remove it from memory
			local data = hc.entityData[entityId]
			local name = data.name
			if entities[name] ~= nil then
				if entities[name].remove ~= nil then
					entities[name].remove(data)
				end
			else
				info("removing "..name.." at: "..entityId)
			end
			hc.entityData[entityId] = nil
		end
	end
	-- ]]--
	global.hardCrafting.schedule[game.tick] = nil
end)

function updatePlayerGui()
	local hc = global.hardCrafting
	for _,player in pairs(game.players) do
		if player.connected then
			local entity = player.opened
			local playerData = hc.playerData[player.name] or {}
			if entity == nil then
				if playerData.gui ~= nil then
					playerData.gui = nil
					warn("Belt-sorter closed")
				end
			elseif playerData.gui == nil then
				if hc.playerData[player.name] == nil then hc.playerData[player.name] = {} end
				
				if entity.name == "belt-sorter" then
					hc.playerData[player.name].gui = "belt-sorter"
					warn("Belt-sorter opened")
				end
			end
		end
	end
end

function dummyUpdate()
	log("starting update")
	local hc = global.hardCrafting
	for entityId,entity in pairs(hc.schedule[game.tick]) do
		local data = hc.entityData[entityId]
		beltSorterSearchInputOutput(entity,data)
	end
	log("input/output search done")
	for entityId,entity in pairs(hc.schedule[game.tick]) do
		local data = hc.entityData[entityId]
		beltSorterBuiltFilter(entity,data)
	end
	log("filter build done")
	for entityId,entity in pairs(hc.schedule[game.tick]) do
		local data = hc.entityData[entityId]
		beltSorterDistributeItems(entity,data)
	end
	log("item distribute done")
	for _,entity in pairs(hc.schedule[game.tick]) do
		scheduleAdd(entity, game.tick + 8)
	end
	log("scheduling done")
	local count = 0
	for _,_ in pairs(hc.schedule[game.tick]) do
		count = count +1
	end
	log("done with "..tostring(count).." belt-sorter")
end

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
	local name = entity.name
	if entities[name] == nil then return end
	global.hardCrafting.entityData[idOfEntity(entity)] = { ["name"] = name }
	if entities[name].build then
		local data = entities[name].build(entity)
		table.addTable(global.hardCrafting.entityData[idOfEntity(entity)],data)
	end
end

---------------------------------------------------
-- Utility methods
---------------------------------------------------
-- Adds new entry to the scheduling table
function scheduleAdd(entity, nextTick)
	if global.hardCrafting.schedule[nextTick] == nil then
		global.hardCrafting.schedule[nextTick] = {}
	end
	global.hardCrafting.schedule[nextTick][idOfEntity(entity)]=entity
end
