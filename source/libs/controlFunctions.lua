

function recipeResultsItemAmount(recipe,itemName)
	for _,itemStack in pairs(recipe.products) do
		if itemStack.name == itemName then
			return itemStack.amount
		end
	end
	return 0
end
