require "defines"
require "libs.entityId"
require "libs.logging"

----------------------------------
-- API
----------------------------------

-- Data used:
-- global.schedule[tick][idEntity] = $entity
-- global.entityData[idEntity] = { name=$name, ... }
-- global.entities_cleanup_required = boolean(check and remove all old events)

-- Register custom entity build, tick or remove function:
-- [$entityName] = { build = $function(entity), tick = $function(entity,data), remove = $function(data) }
entities = {}

-- Required calls in control:
-- entities_build(event)
-- entities_tick()

----------------------------------
----------------------------------

-- Constants:
TICK_ASAP = 0 --game.tick used in migration when game variable is not available yet

---------------------------------------------------
-- init
---------------------------------------------------

function entities_init()
	if global.schedule == nil then global.schedule = {} end
	if global.entityData == nil then global.entityData = {} end
end

---------------------------------------------------
-- Updating Entities
---------------------------------------------------

function entities_tick()
	-- schedule events from migration
	if global.schedule[TICK_ASAP] ~= nil then
		for id,entity in pairs(global.schedule[TICK_ASAP]) do
			local nextTick = game.tick+math.random(60)
			scheduleAdd(entity, nextTick)
		end
		global.schedule[TICK_ASAP] = nil
	end
	
	if global.entities_cleanup_required then
		entities_cleanup_schedule()
		global.entities_cleanup_required = false
	end

	-- if no updates are scheduled return
	if global.schedule[game.tick] == nil then
		return
	end
	
	-- Execute all scheduled events
	for entityId,entity in pairs(global.schedule[game.tick]) do
		if entity and entity.valid then
			local data = global.entityData[entityId]
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
			entities_remove(entityId)
		end
	end
	global.schedule[game.tick] = nil
end

---------------------------------------------------
-- Building Entities
---------------------------------------------------

function entities_build(event)
	local entity = event.created_entity
	local name = entity.name
	if entities[name] == nil then return end
	global.entityData[idOfEntity(entity)] = { ["name"] = name }
	if entities[name].build then
		local data = entities[name].build(entity)
--		info("storing data table for entity "..entity.name.." with id "..idOfEntity(entity)..": "..serpent.block(data))
		table.addTable(global.entityData[idOfEntity(entity)],data)
	end
end

---------------------------------------------------
-- Utility methods
---------------------------------------------------

-- Adds new entry to the scheduling table
function scheduleAdd(entity, nextTick)
	if global.schedule[nextTick] == nil then
		global.schedule[nextTick] = {}
	end
--	info("schedule added for entity "..entity.name.." "..idOfEntity(entity).." at tick: "..nextTick)
	global.schedule[nextTick][idOfEntity(entity)]=entity
end

function entities_remove(entityId)
	local data = global.entityData[entityId]
	local name = data.name
	if entities[name] ~= nil then
		if entities[name].remove ~= nil then
			entities[name].remove(data)
		end
	else
		warn("removing unknown entity: "..name.." at: "..entityId.." with data: "..serpent.block(data))
	end
	global.entityData[entityId] = nil
end

function entities_cleanup_schedule()
	local count = 0
	local toSchedule = {}
	info("starting cleanup. Expect lag... ")
	for tick,array in pairs(global.schedule) do
		if tick < game.tick then
			for entityId,entity in pairs(array) do
				if entity.valid then
					info("found valid entity, scheduling it asap: "..entityId)
					toSchedule[entityId] = entity
				else
					info("found invalid entity, removing it: "..entityId)
					entities_remove(entityId)
				end
			end
			global.schedule[tick] = nil
			count = count + 1
		end
	end
	-- remove all entities that are already scheduled
	for tick,array in pairs(global.schedule) do
			for entityId,entity in pairs(array) do
				toSchedule[entityId] = nil
			end
		end
	for entityId,entity in pairs(toSchedule) do
		scheduleAdd(entity, TICK_ASAP)
	end
	info("Cleanup done. Fixed entities "..count)
end