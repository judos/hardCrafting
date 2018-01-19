require "constants"

function emptyImage()
	return {
		filename = "__"..fullModName.."__/graphics/empty.png",
		priority = "low",
		width = 1,
		height = 1,
		shift = {0,0}
  }
end

function addItem(itemName, subgroup, order, stackSize)
	data:extend({
		{
			type = "item",
			icon_size = 32,
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
		if s["type"] then
			table.insert(resultsDetailled,s)
		else
			local typ = "item"
			if s[1] == "sulfuric-acid" or s[1] == "water" then
				typ = "fluid"
			end
			table.insert(resultsDetailled, {type=typ, name=s[1], amount=s[2]})
		end
	end
	local imageName = removeAfterSign(name,"|")
	data:extend({
	{
		type = "recipe",
	icon_size = 32,
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
