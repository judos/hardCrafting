function entityNamesOfCategory(...)
	local arg = {...}
	local entities = {}
	for i,entityCategory in ipairs(arg) do
		for name, data in pairs(data.raw[entityCategory]) do
			table.insert(entities,name)
		end
	end
	return entities
end

function entitiesOfCategory (...)
	local arg = {...}
	local entities = {}
	for i,entityCategory in ipairs(arg) do
		for name, data in pairs(data.raw[entityCategory]) do
			table.insert(entities,data)
		end
	end
	return entities
end