
function ChangeRecipe(Name, Ingredient1, Ingredient2, Amount)
	for k, v in pairs(data.raw["recipe"][Name].ingredients) do
		if v[1] == Ingredient1 then table.remove(data.raw["recipe"][Name].ingredients, k) end
	end
	table.insert(data.raw["recipe"][Name].ingredients,{Ingredient2, Amount})
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
			return recipe.resultCount or 1
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