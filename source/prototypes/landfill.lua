if data.raw["item"]["dried-dirt"] ~= nil then
	if data.raw["item"]["landfill"] ~= nil then
		data:extend({
			{
				type = "recipe",
				name = "landfill2by2_withDirt",
				enabled = false,
				energy_required = 2,
				ingredients = {
					{"dried-dirt", 20}
				},
				result = "landfill"
			}
		})
	end
end

addTechnologyUnlocksRecipe("landfill","landfill2by2_withDirt")