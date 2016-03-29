if data.raw["item"]["dried-dirt"] ~= nil then
	if data.raw["item"]["landfill2by2"] ~= nil then
		data:extend({
			{
				type = "recipe",
				name = "landfill2by2_withDirt",
				enabled = true,
				ingredients = {
					{"dried-dirt", 25}
				},
				result = "landfill2by2"
			}
		})
	end
end