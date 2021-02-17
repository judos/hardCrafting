-- entitiesTable: table of entities from data.raw table
-- propertyName: may use dots inside the name to access sub properties
function changeEntitiesPropertyByFactor(entitiesTable, propertyName, factor, roundValues, minValue)
	local entitiesName = {}
	for _,data in pairs(entitiesTable) do
		if data[propertyName] then
			data[propertyName] = data[propertyName] * factor
			if roundValues then data[propertyName] = round(data[propertyName]) end
			if minValue then data[propertyName] = math.max(minValue,data[propertyName]) end
			--info(data.name.."."..propertyName.." * "..tostring(factor).." -> "..tostring(data[propertyName]))
		else
			warn(propertyName.." does not exist for "..data.name)
		end
		table.insert(entitiesName, data.name)
	end
	info("Change "..propertyName.." * "..tostring(factor).." for: "..serpent.block(entitiesName))
end
