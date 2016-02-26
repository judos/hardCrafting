require("prototypes.item-group-production")
require("prototypes.incinerator-recipe-category")

-- Item and recipe
data:extend({
  {
    type = "item",
    name = "electric-incinerator",
    icon = "__hardCrafting__/graphics/icons/electric-incinerator.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "b",
    place_result = "electric-incinerator",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "electric-incinerator",
    ingredients = {
			{"stone", 25},{"steel-plate",15},{"iron-gear-wheel",10},{"electric-furnace",2}
		},
		enabled = false,
    result = "electric-incinerator"
  }
})

-- incinerator Entity
local incinerator = deepcopy(data.raw["furnace"]["electric-furnace"])
incinerator.name = "electric-incinerator"
incinerator.crafting_categories = {"incinerator"}
incinerator.energy_usage = "450kW"
incinerator.source_inventory_size = 1
incinerator.result_inventory_size = 1
incinerator.minable.result = "electric-incinerator"
incinerator.module_specification.module_slots = 1
data:extend({ incinerator })

-- technology
local prerequisites = {}
if data.raw["technology"]["incinerator"] ~= nil then
	prerequisites = {"incinerator"}
end

data:extend({
  {
    type = "technology",
    name = "electric-incinerator",
    icon = "__hardCrafting__/graphics/technology/electric-incinerator.png",
    prerequisites = prerequisites,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "electric-incinerator"
      }
    },
    unit = {
      count = 60,
      ingredients = {
        {"science-pack-1", 3},
				{"science-pack-2", 1}
      },
      time = 30
    },
    order = "_incinerator-2"
  }
})
