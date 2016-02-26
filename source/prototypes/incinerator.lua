require("prototypes.item-group-production")
require("prototypes.incinerator-recipe-category")

-- Item and recipe
data:extend({
  {
    type = "item",
    name = "incinerator",
    icon = "__hardCrafting__/graphics/icons/incinerator.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "a",
    place_result = "incinerator",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "incinerator",
    ingredients = {
			{"stone", 25},{"steel-plate",15},{"iron-gear-wheel",10},{"steel-furnace",2}
		},
		enabled = false,
    result = "incinerator"
  }
})

-- incinerator Entity
local incinerator = deepcopy(data.raw["furnace"]["stone-furnace"])
incinerator.name = "incinerator"
incinerator.crafting_categories = {"incinerator"}
incinerator.energy_usage = "300kW"
incinerator.source_inventory_size = 1
incinerator.result_inventory_size = 1
incinerator.minable.result = "incinerator"
data:extend({ incinerator })

-- technology
data:extend({
  {
    type = "technology",
    name = "incinerator",
    icon = "__hardCrafting__/graphics/technology/incinerator.png",
    prerequisites = {},
    effects = {
      {
        type = "unlock-recipe",
        recipe = "incinerator"
      }
    },
    unit = {
      count = 80,
      ingredients = {
        {"science-pack-1", 1}
      },
      time = 30
    },
    order = "_incinerator"
  }
})
