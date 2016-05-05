require "defines"
require "libs.functions"
require "libs.controlFunctions"

knownEntities = {}
require "control.belt-sorter"
require "control.incinerators"
require "control.migration_0_3_11"

modVersion = "0.3.11"

--[[
 global data used:
 hardCrafting.version = $version
 hardCrafting.incinerators = { $incinerator:LuaEntity, ... }
 hardCrafting.eincinerators = { $incinerator:LuaEntity, ... }
 hardCrafting.beltSorter = { $beltSorter:LuaEntity, ... }
 hardCrafting.fbeltSorter = { $fastBeltSorter:LuaEntity, ... }
 
 Currently only belt-sorters use generic setup:
 hardCrafting.schedule[tick][idEntity] = $entity
 hardCrafting.entityData[idEntity] = { name=$name, ... }
]]--

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
	
	if not hc.incinerators then hc.incinerators = {} end
	if not hc.eincinerators then hc.eincinerators = {} end

	if not hc.schedule then hc.schedule = {} end
	if not hc.entityData then hc.entityData = {} end
	
	if hc.version < "0.3.11" then migration_0_3_11() end
end


script.on_event(defines.events.on_tick, function(event)
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
	dummyUpdate()
	--[[
	-- Execute all scheduled events
	for entityId,entity in pairs(hc.schedule[game.tick]) do
		if entity and entity.valid then
			local data = hc.entityData[idOfEntity(entity)]
			local name = entity.name
			local nextUpdateInXTicks, reasonMessage
			if name == "belt-sorter" then
				nextUpdateInXTicks, reasonMessage = beltSorterDidTick(entity,data)
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
			info("removing "..name.." at: "..entityId)
			if name == "belt-sorter" then
				beltSorterWasRemoved(entityId,data)
			end
		end
	end
	]]--
	global.hardCrafting.schedule[game.tick] = nil
end)

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
	if not knownEntities[entity.name] then return end
	if name == "incinerator" then
		table.insert(global.hardCrafting.incinerators,entity)
		return
	elseif name == "electric-incinerator" then
		table.insert(global.hardCrafting.eincinerators,entity)
		return
	end
	
	local data=nil
	if name == "belt-sorter" then
		data = beltSorterWasBuilt(entity)
	end
	if data then 
		global.hardCrafting.entityData[idOfEntity(entity)] = { ["name"] = name }
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
