if data.raw["item"]["dirt"] ~= nil then
	if data.raw["item"]["landfill"] ~= nil then
		data:extend({
			{
				type = "recipe",
				name = "landfill2by2_withDirt",
				enabled = false,
				order= "c[landfill]-b[sand]",
				energy_required = 2,
				ingredients = {
					{"sand", 30}
				},
				icon = "__"..fullModName.."__/graphics/icons/landfill-from-sand.png",
				icon_size=32,
				result = "landfill"
			}
		})
	end
end

addTechnologyUnlocksRecipe("landfill","landfill2by2_withDirt")