-- Incinerator hidden Recipes
-- This file must be included only in data-final-fixes, otherwise not all items can be inserted in the incinerator

local types = {"item", "gun", "armor", "ammo", "blueprint", "deconstruction-item"}
for _,typ in pairs(types) do
	for name,itemTable in pairs(data.raw[typ]) do
		data:extend({
			{
				type = "recipe",
				name = "incinerate_"..name,
				category = "incinerator",
				icon = "__hardCrafting__/graphics/icons/fire.png",
				hidden = true,
				ingredients = {{name, 1}},
				energy_required = 4,
				results =
				{
					{type="item", name="coal", probability=0.1, amount_min=1, amount_max=1},
				}
			}
		})
	end
end
