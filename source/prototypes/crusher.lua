require("prototypes.item-group-production")

data:extend({
  {
    type = "item",
    name = "crusher",
    icon = "__hardCrafting__/graphics/icons/crusher.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "f",
    place_result = "crusher",
		enabled = false,
    stack_size = 50
  },
	{
    type = "recipe",
    name = "crusher",
    ingredients = {
			{"stone", 15},{"electronic-circuit",2},{"iron-gear-wheel",5}
		},
		enabled = false,
    result = "crusher"
  },
	{
    type = "recipe-category",
    name = "crusher"
  },
})

-- Entity
local crusher = deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
crusher.name = "crusher"
crusher.crafting_categories = {"crusher"}
crusher.energy_usage = "80kW"
crusher.source_inventory_size = 1
crusher.result_inventory_size = 3
crusher.crafting_speed = 1
crusher.minable.result = "crusher"

crusher.icon =  "__hardCrafting__/graphics/icons/crusher.png"
crusher.animation = deepcopy(data.raw["furnace"]["electric-furnace"].animation)
crusher.animation.filename="__hardCrafting__/graphics/entity/crusher/crusher-base.png"

crusher.working_sound = data.raw["furnace"]["electric-furnace"].working_sound
crusher.open_sound  = data.raw["furnace"]["electric-furnace"].open_sound
crusher.close_sound  = data.raw["furnace"]["electric-furnace"].close_sound 

data:extend({ crusher })

-- technology
data:extend({
  {
    type = "technology",
    name = "crusher",
    icon = "__hardCrafting__/graphics/icons/crusher.png",
    prerequisites = {},
    effects = {
      {
        type = "unlock-recipe",
        recipe = "crusher"
      }
    },
    unit = {
      count = 42,
      ingredients = {
        {"science-pack-1", 1}
      },
      time = 20
    },
    order = "_crusher"
  }
})