-- Incinerator hidden Recipes
-- This file must be included only in data-final-fixes, otherwise not all items can be inserted in the incinerator

data:extend({
			{
				type = "item",
				name = "fire_item",
				hidden = true,
				enabled = false,
				icon = "__hardCrafting__/graphics/icons/fire.png",
				flags = {"goes-to-quickbar"},
				stack_size = 50
			}
		})

local types = {"item", "gun", "armor", "ammo", "blueprint", "deconstruction-item"}
for _,typ in pairs(types) do
	for name,itemTable in pairs(data.raw[typ]) do
		data:extend({
			{
				type = "recipe",
				name = "incinerate_"..name,
				category = "incinerator",
				hidden = true,
				ingredients = {{name, 1}},
				result = "fire_item",
				energy_required = 5,
				result_count = 0
			}
		})
	end
end