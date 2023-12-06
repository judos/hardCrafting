require "libs.prototypes.recipe"

rawIngredients = {} -- [item][resourceName] = amount
local logs = false

local function logFindRaw(msg)
	if logs then info(msg) end
end

function findRawIngredient(itemName,rawResourceName)
	logFindRaw("how much "..rawResourceName.." is required for "..itemName.." ?")
	-- initialize
	if not rawIngredients[itemName] then rawIngredients[itemName]={} end
	if itemName == rawResourceName then
		rawIngredients[itemName][rawResourceName] = 1
		logFindRaw("that's already the right item")
		return 1
	end

	-- if cached:
	if rawIngredients[itemName][rawResourceName] then
		logFindRaw("found in cache: "..tostring(rawIngredients[itemName][rawResourceName]).." "..rawResourceName.." gives "..itemName)
		return rawIngredients[itemName][rawResourceName]
	end
	rawIngredients[itemName][rawResourceName] = 0

	-- find first recipe (assuming there is only one!)
	local firstRecipe = nil
	for recipeName,recipe in pairs(data.raw["recipe"]) do
		if recipeResultsContain(recipe,itemName) then
			firstRecipe = recipe
			break
		end
	end

	if not firstRecipe then
		logFindRaw("No recipe found to make "..itemName.." out of "..rawResourceName)
		return 0
	end
	
	-- get output count
	local output = recipeResultsItemAmount(firstRecipe,itemName)
	logFindRaw("found recipe "..firstRecipe.name.." with "..tostring(output).." output")

	-- get ingredients
	local ingredients = {}
	local ingredientList = firstRecipe.ingredients or firstRecipe.normal.ingredients
	for _,itemStack in pairs(ingredientList) do
		if itemStack["name"] then
			ingredients[itemStack["name"]] = itemStack["amount"]
		else
			ingredients[itemStack[1]] = itemStack[2]
		end
	end
	
	logFindRaw("ingredients for this recipe: "..serpent.block(ingredients))

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
