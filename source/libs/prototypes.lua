require "constants"

function addItem(itemName, subgroup, order, stackSize)
	data:extend({
		{
			type = "item",
			name = itemName,
			icon = "__"..fullModName.."__/graphics/icons/"..itemName..".png",
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
		local typ = "item"
		if s[1] == "sulfuric-acid" or s[1] == "water" then
			typ = "fluid"
		end
		table.insert(resultsDetailled, {type=typ, name=s[1], amount=s[2]})
	end
	local imageName = removeAfterSign(name,"|")
	data:extend({
	{
		type = "recipe",
    name = name,
    category = category,
		subgroup = subgroup,
    energy_required = timeRequired,
    ingredients = ingredients,
		icon = "__"..fullModName.."__/graphics/icons/"..imageName..".png",
    results = resultsDetailled,
		order = order
	}
	})
end
