
rawIngredients = {} -- [item][resourceName] = amount


function findRawIngredient(itemName,rawResourceName)
	-- initialize
	if not rawIngredients[itemName] then rawIngredients[itemName]={} end
	if itemName == rawResourceName then
		rawIngredients[itemName][rawResourceName] = 1
		return 1
	end

	-- if cached:
	if rawIngredients[itemName][rawResourceName] then
		return rawIngredients[itemName][rawResourceName]
	end
	rawIngredients[itemName][rawResourceName] = 0

	-- find first recipe (assuming there is only one!)
	local firstRecipe = nil
	for recipeName,recipe in pairs(data.raw["recipe"]) do
		if recipe.result == itemName then
			firstRecipe = recipe
			break
		end
		if recipe.results then
			for _,resultItemStack in pairs(recipe.results) do
				if resultItemStack["name"] == itemName then
					firstRecipe = recipe
					break
				end
			end
			if firstRecipe then break end
		end
	end

	if not firstRecipe then
		--warn("No ingredient "..rawResourceName.." found for "..itemName)
		return 0
	end

	-- get output count
	local output = firstRecipe.result_count or 1
	if firstRecipe.results then
		for _,itemStack in pairs(firstRecipe.results) do
			if itemStack["name"] == itemName then
				output = itemStack["amount"] or 1 --if amount is not set it is interpreted as 1
				break
			end
		end
	end

	-- get ingredients
	local ingredients = {}
	for _,itemStack in pairs(firstRecipe.ingredients) do
		if itemStack["name"] then
			ingredients[itemStack["name"]] = itemStack["amount"]
		else
			ingredients[itemStack[1]] = itemStack[2]
		end
	end

	-- calculate for all sub ingredients
	for name,amount in pairs(ingredients) do
		if not rawIngredients[name] or not rawIngredients[name][rawResourceName] then
			findRawIngredient(name,rawResourceName)
		end
		rawIngredients[itemName][rawResourceName] = rawIngredients[itemName][rawResourceName] + 
			amount * rawIngredients[name][rawResourceName] / output
	end

	return rawIngredients[itemName][rawResourceName]
end
