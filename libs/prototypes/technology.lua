-- technologies: "all", or specific technology, or a table of tech-names
-- factor: by how much to increase or decrease the cost of a research step
-- NOTE: most technologies cost already only 1 science pack (times some amount), so factor < 1 won't do anything
function technologyChangeIngredientsAmountByFactor(techNames,items,factor)
	info("The following technologies will cost "..tostring(factor).."x times of "..serpent.block(items)..": "..serpent.block(techNames))
	if type(techNames) == "string" then
		techNames = {techNames}
	elseif type(techNames) ~= "table" then
		err("techNames passed are not a string or table: "..serpent.block(techNames))
		return
	end
	if type(items) == "string" then
		items = {items}
	elseif type(items) ~= "table" then
		err("items passed are not a string or table: "..serpent.block(items))
		return
	end
	local techSet = table.set(techNames)
	local itemSet = table.set(items)
	for _,tech in pairs(data.raw.technology) do
		if techSet[tech.name] or techSet["all"] then
			for _,data in pairs(tech.unit.ingredients) do
				if itemSet[data[1]] or itemSet["all"] then
					data[2] = math.max(1,round(data[2] * factor,0))
				end
			end
		end
	end
end

-- technologies: "all", or specific technology, or a table of tech-names
-- factor: by how much to increase or decrease the amount of all science packs needed
function technologyChangeAmountByFactor(techNames,factor)
	info("The following technologies will cost "..tostring(factor).."x times: "..serpent.block(techNames))
	if type(techNames) == "string" then
		techNames = {techNames}
	elseif type(techNames) ~= "table" then
		err("techNames passed are not a string or table: "..serpent.block(techNames))
		return
	end
	local techSet = table.set(techNames)
	for _,tech in pairs(data.raw.technology) do
		if techSet[tech.name] or techSet["all"] then
			tech.unit.count = math.max(1,round(tech.unit.count * factor,0))
		end
	end
end

-- adds a recipe which is unlocked when the given technology is researched
function addTechnologyUnlocksRecipe(technologyName, recipeName)
	local tech = data.raw["technology"][technologyName]
	if tech then
		local recipe = data.raw.recipe[recipeName]
		if recipe == nil then
			error("Technology "..technologyName.." should unlock "..recipeName.." but recipe is not initialized yet")
		else
			data.raw["recipe"][recipeName].enabled = false
			if tech.effects == nil then
				tech.effects = {}
			end
			table.insert(tech.effects, {type = "unlock-recipe", recipe = recipeName })
		end
	else
		error("Technology "..technologyName.." not found when adding recipe "..recipeName..". Did you mean?")
		for name,_ in pairs(data.raw["technology"]) do
			error(" "..name)
		end
	end
end
