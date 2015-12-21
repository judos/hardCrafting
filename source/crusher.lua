data:extend({
  {
    type = "item",
    name = "crusher",
    icon = "__base__/graphics/icons/electric-furnace.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "f",
    place_result = "crusher",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "crusher",
    ingredients = {
			{"stone", 15},{"electronic-circuit",2},{"iron-gear-wheel",5}
		},
    result = "crusher"
  },
	{
    type = "recipe-category",
    name = "crusher"
  },
})

-- Recycler Entity
local crusher = deepcopy(data.raw["furnace"]["electric-furnace"])
crusher.name = "crusher"
crusher.crafting_categories = {"crusher"}
crusher.energy_usage = "80kW"
crusher.minable.result = "crusher"
crusher.source_inventory_size = 1
crusher.result_inventory_size = 3
crusher.crafting_speed = 1
data:extend({ crusher })
