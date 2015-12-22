-- Recycling hidden Recipes

data:extend({
			{
				type = "item",
				name = "recycle_item",
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
				name = "recycle_"..name,
				category = "recycling",
				hidden = true,
				ingredients = {{name, 1}},
				result = "recycle_item",
				energy_required = 5,
				result_count = 0
			}
		})
	end
end