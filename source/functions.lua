function addItem(itemName, subgroup, order, stackSize)
	data:extend({
		{
			type = "item",
			name = itemName,
			icon = "__hardCrafting__/graphics/icons/"..itemName..".png",
			flags = {"goes-to-main-inventory"},
			subgroup = subgroup,
			order = order,
			stack_size = stackSize
		}
	})
end


function addRecipe(name,category,subgroup,timeRequired,ingredients,results,order)
	local resultsDetailled = {}
	if not results then
		print("No results found for recipe with name: "..name)
	end
	for _,s in pairs(results) do
		table.insert(resultsDetailled, {type="item", name=s[1], amount=s[2]})
	end
	imageName = removeAfterSign(name,"|")
	data:extend({
	{
		type = "recipe",
    name = name,
    category = category,
		subgroup = subgroup,
    energy_required = timeRequired,
    ingredients = ingredients,
		icon = "__hardCrafting__/graphics/icons/"..imageName..".png",
    results = resultsDetailled,
		order = order
	}
	})
end

function removeAfterSign(str, separator)
	local pos = str:find(separator)
	if pos == nil then return str end
	return str:sub(1,pos-1)
end

-- adds a recipe which is unlocked when the given technology is researched
function addTechnologyUnlocksRecipe(technologyName, recipeName)
	table.insert(data.raw["technology"][technologyName].effects,
		{ type = "unlock-recipe", recipe = recipeName })
end


function ChangeRecipe(Name, Ingredient1, Ingredient2, Amount)
	for k, v in pairs(data.raw["recipe"][Name].ingredients) do
		if v[1] == Ingredient1 then table.remove(data.raw["recipe"][Name].ingredients, k) end
	end
table.insert(data.raw["recipe"][Name].ingredients,{Ingredient2, Amount})
end