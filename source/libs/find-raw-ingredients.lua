
rawIngredients = {} -- [item][resourceName] = amount
local function l(msg)
	--info(msg)
end

function findRawIngredient(itemName,rawResourceName)
	l("searching: "..rawResourceName.." -> "..itemName)
	-- initialize
	if not rawIngredients[itemName] then rawIngredients[itemName]={} end
	if itemName == rawResourceName then
		rawIngredients[itemName][rawResourceName] = 1
		l("itself using factor 1")
		return 1
	end

	-- if cached:
	if rawIngredients[itemName][rawResourceName] then
		l("it's cached: factor: "..tostring(rawIngredients[itemName][rawResourceName]))
		return rawIngredients[itemName][rawResourceName]
	end
	rawIngredients[itemName][rawResourceName] = 0

	-- find first recipe (assuming there is only one!)
	local firstRecipe = nil
	for recipeName,recipe in pairs(data.raw["recipe"]) do
		if recipe.result == itemName or (recipe.normal and recipe.normal.result == itemName) then
			firstRecipe = recipe
			break
		end
		local r = recipe.results or (recipe.normal~=nil and recipe.normal.results)
		if r then
			for _,resultItemStack in pairs(r) do
				if resultItemStack["name"] == itemName then
					firstRecipe = recipe
					break
				end
			end
			if firstRecipe then break end
		end
	end

	if not firstRecipe then
		l("No recipe found with ingredient "..rawResourceName.." for "..itemName)
		return 0
	end
	l("recipe found: "..firstRecipe.name)

	-- get output count
	local output = firstRecipe.result_count or firstRecipe.normal.result_count or 1
	local r = firstRecipe.results or firstRecipe.normal.results
	if r then
		for _,itemStack in pairs(r) do
			if itemStack["name"] == itemName then
				output = itemStack["amount"] or 1 --if amount is not set it is interpreted as 1
				break
			end
		end
	end
	l("output is: "..tostring(output))

	-- get ingredients
	local ingredients = {}
	local i = firstRecipe.ingredients or firstRecipe.normal.ingredients
	for _,itemStack in pairs(i) do
		if itemStack["name"] then
			ingredients[itemStack["name"]] = itemStack["amount"]
		else
			ingredients[itemStack[1]] = itemStack[2]
		end
	end
	l("ingredients are: "..serpent.block(ingredients))

	-- calculate for all sub ingredients
	for name,amount in pairs(ingredients) do
		if not rawIngredients[name] or not rawIngredients[name][rawResourceName] then
			findRawIngredient(name,rawResourceName)
		end
		rawIngredients[itemName][rawResourceName] = rawIngredients[itemName][rawResourceName] + 
			amount * rawIngredients[name][rawResourceName] / output
	end
	
	l("calculated amount is: "..tostring(rawIngredients[itemName][rawResourceName]))

	return rawIngredients[itemName][rawResourceName]
end
