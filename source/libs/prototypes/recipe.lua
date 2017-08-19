function recipeChangeResultsForItemsByFactor(itemNameS, factor, roundValues)
	if type(itemNameS) == "string" then
		itemNameS = { itemNameS }
	elseif type(itemNameS) ~= "table" then
		err("Invalid type of argument passed: "..serpent.block(itemNameS))
		return
	end
	info("All recipes will results "..tostring(factor).."x "..serpent.block(itemNameS))
	local itemNamesSet = table.set(itemNameS)	-- convert itemNames table to set
	-- loop through all recipes and change costs for that item
	for _,recipe in pairs(data.raw.recipe) do
		if recipe.result then
			if itemNamesSet[recipe.result] then
				recipe.result_count = (recipe.result_count or 1) * factor
				if roundValues then recipe.result_count = round(recipe.result_count) end
			end
		else
			for _,data in pairs(recipe.results) do
				if itemNamesSet[data.name] then
					data.amount = (data.amount or 1) * factor
					if roundValues then data.amount = round(data.amount) end
				end
			end
		end
	end
end

function recipeChangeCostsForItemsByFactor(itemNameS, factor, roundValues)
	if type(itemNameS) == "string" then
		itemNameS = { itemNameS }
	elseif type(itemNameS) ~= "table" then
		err("Invalid type of argument passed: "..serpent.block(itemNameS))
		return
	end
	info("All recipes will cost "..tostring(factor).."x "..serpent.block(itemNameS))
	local itemNamesSet = table.set(itemNameS)	-- convert itemNames table to set
	-- loop through all recipes and change costs for that item
	for _,recipe in pairs(data.raw.recipe) do
		for _,data in pairs(recipe.ingredients) do
			if data.type and itemNamesSet[data.name] then
				data.amount = data.amount * factor
				if roundValues then data.amount = round(data.amount) end
			elseif itemNamesSet[data[1]] then
				data[2] = data[2] * factor
				if roundValues then data[2] = round(data[2]) end
			end
		end
	end
end

function recipeNamesOfItems(itemNameS)
	if type(itemNameS) == "string" then
		itemNameS = { itemNameS }
	elseif type(itemNameS) ~= "table" then
		err("Invalid type of argument passed: "..serpent.block(itemNameS))
		return
	end
	local itemNamesSet = table.set(itemNameS)	-- convert itemNames table to set

	-- loop through all recipes and put recipeNames in set
	local recipeNamesSet = {}
	for recipeName,data in pairs(data.raw.recipe) do
		if data.result and itemNamesSet[data.result] then
			recipeNamesSet[recipeName] = true
		elseif data.results then 
			for _,resultData in pairs(data.results) do
				if itemNamesSet[resultData.name] then
					recipeNamesSet[recipeName] = true
					break
				end
			end
		end
	end
	
	return set.table(recipeNamesSet) -- convert set of recipeNames to table
end

-- recipeNameS: can be a name of a recipe or a table of names
function recipeChangeCostsByFactor(recipeNameS, factor, roundValues)
	if type(recipeNameS) == "string" then
		recipeNameS = { recipeNameS }
	elseif type(recipeNameS) ~= "table" then
		err("Invalid type of argument passed: "..serpent.block(recipeNameS))
		return
	end
	info("These recipes will cost "..tostring(factor).."x of everything: "..serpent.block(recipeNameS))
	for _,name in pairs(recipeNameS) do
		local recipe = data.raw.recipe[name]
		for _,data in pairs(recipe.ingredients) do
			if data.type then
				data.amount = (data.amount or 1) * factor
				if roundValues then data.amount = round(data.amount) end
			else
				data[2] = (data[2] or 1) * factor
				if roundValues then data[2] = round(data[2]) end
			end
		end
	end
end

-- recipeNameS: can be a name of a recipe or a table of names
function recipeChangeResultByFactor(recipeNameS,factor, roundValues)
	if type(recipeNameS) == "string" then
		recipeNameS = { recipeNameS }
	elseif type(recipeNameS) ~= "table" then
		err("Invalid type of argument passed: "..serpent.block(recipeNameS))
		return
	end
	info("These recipes will result "..tostring(factor).."x of everything: "..serpent.block(recipeNameS))
	for _,name in pairs(recipeNameS) do
		local recipe = data.raw.recipe[name]
		if recipe.result then
			recipe.result_count = (recipe.result_count or 1) * factor
			if roundValues then recipe.result_count = round(recipe.result_count) end
			--info(name.." results * "..tostring(factor).." -> "..tostring(recipe.result_count))
		else
			for _,data in pairs(recipe.results) do
				data.amount = (data.amount or 1) * factor
				if roundValues then data.amount = round(data.amount) end
				--info(name.." results * "..tostring(factor).." -> "..tostring(data.amount).." "..data.name)
			end
		end
	end
end

-- To be removed in 3.0
function ChangeRecipe(Name, Ingredient1, Ingredient2, Amount)
	error("Use recipeReplaceIngredient function instead")
end

function recipeReplaceIngredient(name, ingredient1, ingredient2, amount)
	for k, v in pairs(data.raw["recipe"][name].ingredients) do
		if v[1] == ingredient1 then table.remove(data.raw["recipe"][name].ingredients, k) end
	end
	table.insert(data.raw["recipe"][name].ingredients,{ingredient2, amount})
end


function recipeItemAmount(recipe,itemName)
	for _,tuple in pairs(recipe.ingredients) do
		if tuple[1] == itemName then 
			return tuple[2]
		end
	end
	return 0
end

function recipeResultsItemAmount(recipe,itemName)
	if recipe.results == nil then
		if recipe.result == itemName then
			return recipe.result_count or 1
		end
		return 0
	end
	for _,tuple in pairs(recipe.results) do
		if tuple[1] == itemName then
			return tuple[2]
		end
	end
	return 0
end

-- ingredient must be e.g. { type="item", name="stone", amount="1" }
function recipeAddIngredient(recipe,ingredientNew)
	for _,ingredient in pairs(recipe.ingredients) do
		if ingredient.type == ingredientNew.type and ingredient.name == ingredientNew.name then
			ingredient.amount = ingredient.amount + ingredientNew.amount
			return
		end
	end
	table.insert(recipe.ingredients,ingredientNew)
end