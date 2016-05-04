
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