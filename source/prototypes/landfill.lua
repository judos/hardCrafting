if data.raw["item"]["dirt"] ~= nil then
	if data.raw["item"]["landfill"] ~= nil then
		data:extend({
			{
				type = "recipe",
				name = "landfill2by2_withDirt",
				enabled = false,
				energy_required = 2,
				ingredients = {
					{"dirt", 20}
				},
				result = "landfill"
			}
		})
	end
end

addTechnologyUnlocksRecipe("landfill","landfill2by2_withDirt")