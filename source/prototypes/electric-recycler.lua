require("prototypes.item-group-production")

data:extend({
  {
    type = "item",
    name = "electric-recycler",
    icon = "__base__/graphics/icons/electric-furnace.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "b",
    place_result = "electric-recycler",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "electric-recycler",
    ingredients = {
			{"stone", 25},{"steel-plate",15},{"iron-gear-wheel",10},{"electric-furnace",2}
		},
    result = "electric-recycler"
  }
})

-- Recycler Entity
local recycler = deepcopy(data.raw["furnace"]["electric-furnace"])
recycler.name = "electric-recycler"
recycler.crafting_categories = {"recycling"}
recycler.energy_usage = "600kW"
recycler.minable.result = "electric-recycler"
recycler.module_specification.module_slots = 1
data:extend({ recycler })
