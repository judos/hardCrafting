require "libs.control.surfaces"

function idOfEntity(entity)
	assert2(entity,"entity provided must not be nil")
	return idOfPosition(entity.surface.index, entity.position.x, entity.position.y, entity.name)
end

function idOfPosition(surfaceIndex,x,y,entityName)
	if not entityName then
		err("Missing parameter 'entityName' for idOfPosition method")
	end
	return string.format("%i_%g_%g_%s", surfaceIndex, x, y, entityName)
end

function positionOfId(id)
	if id == nil then
		err("Got nil when searching entity for id.\n"..debug.traceback())
	end
	local position = split(id,"_")
	return {
		surfaceIndex = tonumber(position[1]),
		position = {x=tonumber(position[2]),y=tonumber(position[3])},
		entityName = position[4]
	}
end

function entityOfId(id,searchName)
	local location = positionOfId(id)
	local entities = surfaceWithIndex(location.surfaceIndex).find_entities_filtered{position=location.position,name=location.entityName}
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

