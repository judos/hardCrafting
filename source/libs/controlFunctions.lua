
function idOfEntity(entity)
	return string.format("%g_%g", entity.position.x, entity.position.y)
end


function entityOfId(id,searchName)
	if id == nil then
		err("Got nil when searching entity for id.\n"..debug.traceback())
	end
	local position = split(id,"_")
	local point = {tonumber(position[1]),tonumber(position[2])}
	local entities = game.surfaces.nauvis.find_entities{point,point}
	if entities == nil or #entities ==0 then
		err("No entity found for id provided: "..id)
		return nil
	end
	if #entities > 1 then
		if searchName then
			local result
			local found = 0
			for k,entity in pairs(entities) do
				if entity.name == searchName then
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


function recipeResultsItemAmount(recipe,itemName)
	for _,itemStack in pairs(recipe.products) do
		if itemStack.name == itemName then
			return itemStack.amount
		end
	end
	return 0
end
