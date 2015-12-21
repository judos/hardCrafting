data:extend({
  {
    type = "item",
    name = "recycler",
    icon = "__base__/graphics/icons/stone-furnace.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "a",
    place_result = "recycler",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "recycler",
    ingredients = {
			{"stone", 25},{"steel-plate",15},{"iron-gear-wheel",10},{"steel-furnace",2}
		},
    result = "recycler"
  },
	{
    type = "recipe-category",
    name = "recycling"
  },
})

-- Recycler Entity
local recycler = deepcopy(data.raw["furnace"]["stone-furnace"])
recycler.name = "recycler"
recycler.crafting_categories = {"recycling"}
recycler.energy_usage = "400kW"
recycler.minable.result = "recycler"
data:extend({ recycler })
