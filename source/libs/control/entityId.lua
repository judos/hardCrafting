require "libs.control.surfaces"

function idOfEntity(entity)
	assert2(entity,"entity provided must not be nil")
	return string.format("%i_%g_%g", entity.surface.index, entity.position.x, entity.position.y)
end


function entityOfId(id,searchName)
	if id == nil then
		err("Got nil when searching entity for id.\n"..debug.traceback())
	end
	local position = split(id,"_")
	local surfaceIndex = tonumber(position[1])
	local point = {x=tonumber(position[2]),y=tonumber(position[3])}
	local entities = surfaceWithIndex(surfaceIndex).find_entities_filtered{position=point}
	if entities == nil or #entities ==0 then
		err("No entity found for id provided: "..id)
		return nil
	elseif #entities == 1 then
		return entities[1]
	end
	
	if not searchName then
		warn("Using at random the first entity")
		return entities[1]
	end
	
	warn("Multiple entities found for id provided: "..id)
	local result = nil
	local found = 0
	for k,entity in pairs(entities) do
		if entity.name == searchName then
			return entity
		end
		if entity.name:find(searchName) then
			result = entity
			found = found + 1
		end
	end
	if found ~= 1 then
		warn("entitiyOfId found "..tostring(found).." entities with name "..searchName.." for id "..id)
	end
	return result
end




function idOfEntity_v21(entity)
	return string.format("%g_%g", entity.position.x, entity.position.y)
end


function entityOfId_v21(id,searchName)
	if id == nil then
		err("Got nil when searching entity for id.\n"..debug.traceback())
	end
	local position = split(id,"_")
	local point = {tonumber(position[1]),tonumber(position[2])}
	local entities = game.surfaces.nauvis.find_entities_filtered{position=point}
	if entities == nil or #entities ==0 then
		err("No entity found for id provided: "..id)
		return nil
	end
	if #entities > 1 then
		if searchName then
			local result
			local found = 0
			for k,entity in pairs(entities) do
				if entity.name:find(searchName) then
					result = entity
					found = found + 1
				end
			end
			if found ~= 1 then
				warn("entitiyOfId found "..tostring(found).." entities with name "..searchName.." for id "..id)
			end
			if result then return result end
		end
		warn("Multiple entities found for id provided: "..id.." using entity with name: "..entities[1].name)
		for k,entity in pairs(entities) do
			info("available: "..tostring(k).." = "..entity.name)
		end
	end
	return entities[1]
end
