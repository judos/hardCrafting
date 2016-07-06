require "libs.entityId"
require "libs.logging"

-- --------------------------------
-- API V2
-- --------------------------------

-- Data used:
-- global.schedule[tick][idEntity] = { entity = $entity, [noTick = true] }
-- global.entityData[idEntity] = { name=$name, ... }
-- global.entities_cleanup_required = boolean(check and remove all old events)

-- Register custom entity build, tick or remove function:
-- [$entityName] = { build = $function(entity):dataArr,
--                   tick = $function(entity,data):(nextTick,reason),
--                   remove = $function(data) }
entities = {}

-- Required calls in control:
-- entities_build(event)
-- entities_tick()
-- entities_pre_mined(event)

-- --------------------------------
-- --------------------------------

-- Constants:
TICK_ASAP = 0 --game.tick used in migration when game variable is not available yet
TICK_SOON = 1 --game.tick used in cleanup when entity should be schedule randomly in next 1s

-- -------------------------------------------------
-- init
-- -------------------------------------------------

function entities_init()
	if global.schedule == nil then global.schedule = {} end
	if global.entityData == nil then global.entityData = {} end
end

-- -------------------------------------------------
-- Updating Entities
-- -------------------------------------------------

function entities_tick()
	-- schedule events from migration
	if global.schedule[TICK_ASAP] ~= nil then
		if global.schedule[game.tick] == nil then global.schedule[game.tick] = {} end
		for id,arr in pairs(global.schedule[TICK_ASAP]) do
			info("scheduled entity "..id.." for now. "..serpent.block(arr))
			global.schedule[game.tick][id] = arr
		end
		global.schedule[TICK_ASAP] = nil
	end
	if global.schedule[TICK_SOON] ~= nil then
		for id,arr in pairs(global.schedule[TICK_SOON]) do
			local nextTick = game.tick + math.random(60)
			if global.schedule[nextTick] == nil then global.schedule[nextTick] = {} end
			global.schedule[nextTick][id] = arr
		end
		global.schedule[TICK_SOON] = nil
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
	local entityIdsToClear = {}
	for entityId,arr in pairs(global.schedule[game.tick]) do
		local entity = arr.entity
		if entity and entity.valid then
			if not arr.noTick then
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
			end
		elseif entityId == "text" then
			PlayerPrint(entity)
		else
			-- if entity was removed, remove it from memory
			entities_remove(entityId)
			if arr.clearSchedule then
				table.insert(entityIdsToClear,entityId)
			end
		end
	end
	global.schedule[game.tick] = nil
	if #entityIdsToClear > 0 then
		for tick,tickSchedule in pairs(global.schedule) do
			for _,id in pairs(entityIdsToClear) do
				tickSchedule[id] = nil
			end
		end
	end
end

-- -------------------------------------------------
-- Building Entities
-- -------------------------------------------------

function entities_build(event)
	local entity = event.created_entity
	local name = entity.name
	if entities[name] == nil then return false end
	global.entityData[idOfEntity(entity)] = { ["name"] = name }
	if entities[name].build then
		local data = entities[name].build(entity)
		if data then
			-- info("storing data table for entity "..entity.name.." with id "..idOfEntity(entity)..": "..serpent.block(data))
			table.addTable(global.entityData[idOfEntity(entity)],data)
		end
	end
	return true
end

-- -------------------------------------------------
-- Premining
-- -------------------------------------------------

function entities_pre_mined(event)
	-- { entity Lua/Entity, name = 9, player_index = 1, tick = 96029 }
	local entity = event.entity
	local name = entity.name
	if entities[name] == nil then return end
	if entities[name].premine then
		local data = global.entityData[idOfEntity(entity)]
		entities[name].premine(entity,data,game.players[event.player_index])
	end
	local checkEntity = scheduleAdd(entity,0)
	checkEntity.noTick = true
	checkEntity.clearSchedule = true
end

-- -------------------------------------------------
-- Utility methods
-- -------------------------------------------------

function scheduleAdd(entity, nextTick)
	if global.schedule[nextTick] == nil then
		global.schedule[nextTick] = {}
	end
	--	info("schedule added for entity "..entity.name.." "..idOfEntity(entity).." at tick: "..nextTick)
	local update = { entity = entity }
	global.schedule[nextTick][idOfEntity(entity)] = update
	return update
end

function entities_remove(entityId)
	local data = global.entityData[entityId]
	if not data then return end
	local name = data.name
	if entities[name] ~= nil then
		if entities[name].remove ~= nil then
			entities[name].remove(data)
		end
	else
		warn("removing unknown entity: "..name.." at: "..entityId) -- .." with data: "..serpent.block(data))
	end
	global.entityData[entityId] = nil
end

function entities_cleanup_schedule()
	local count = 0
	local toSchedule = {}
	info("starting cleanup. Expect lag... ")
	for tick,array in pairs(global.schedule) do
		if tick < game.tick then
			for entityId,arr in pairs(array) do
				if arr.entity.valid then
					if toSchedule[entityId]==nil then
						info("found valid entity, scheduling it asap: "..entityId)
						toSchedule[entityId] = arr.entity
					end
				else
					info("found invalid entity, removing it: "..entityId)
					entities_remove(entityId)
				end
				count = count + 1
			end
			global.schedule[tick] = nil

		end
	end
	-- remove all entities that are already scheduled
	for _,array in pairs(global.schedule) do
		for entityId,_ in pairs(array) do
			toSchedule[entityId] = nil
		end
	end
	for _,entity in pairs(toSchedule) do
		scheduleAdd(entity, TICK_SOON)
	end
	info("Cleanup done. Fixed entities "..count)
end

-- -------------------------------------------------
-- Migration
-- -------------------------------------------------
function entities_migration_V2()
	for tick,arr in pairs(global.schedule) do
		for id,entity in pairs(arr) do
			arr[id] = { entity = entity }
		end
	end
end
