require "defines"
require "libs.entityId"
require "libs.logging"

----------------------------------
-- API
----------------------------------

-- Data used:
-- global.schedule[tick][idEntity] = $entity
-- global.entityData[idEntity] = { name=$name, ... }

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
			scheduleAdd(entity, game.tick+math.random(60))
		end
		global.schedule[TICK_ASAP] = nil
	end

	-- if no updates are scheduled return
	if global.schedule[game.tick] == nil then
		return
	end
	
	-- Execute all scheduled events
	for entityId,entity in pairs(global.schedule[game.tick]) do
		if entity and entity.valid then
			local data = global.entityData[idOfEntity(entity)]
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
			local data = global.entityData[entityId]
			local name = data.name
			if entities[name] ~= nil then
				if entities[name].remove ~= nil then
					entities[name].remove(data)
				end
			else
				info("removing "..name.." at: "..entityId)
			end
			global.entityData[entityId] = nil
		end
	end
	global.hardCrafting.schedule[game.tick] = nil
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
	global.schedule[nextTick][idOfEntity(entity)]=entity
end