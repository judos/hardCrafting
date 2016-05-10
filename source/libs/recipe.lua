
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