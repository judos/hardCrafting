require("prototypes.item-group-production")

data:extend({
  {
    type = "item",
    name = "crusher",
    icon = "__hardCrafting__/graphics/icons/crusher_icon.png",
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
crusher.energy_source.emissions = 0.005

crusher.icon =  "__hardCrafting__/graphics/icons/crusher_icon.png"
crusher.animation =
{
  filename = "__hardCrafting__/graphics/entity/animation/crusher_animation.png",
  priority = "high",
  width = 129,
  height = 100,
  frame_count = 4,
  animation_speed = 1,
  shift = {0.5, -0.2375}
}

crusher.working_sound = data.raw["furnace"]["electric-furnace"].working_sound
crusher.open_sound  = data.raw["furnace"]["electric-furnace"].open_sound
crusher.close_sound  = data.raw["furnace"]["electric-furnace"].close_sound 

data:extend({ crusher })

-- technology
data:extend({
  {
    type = "technology",
    name = "crusher",
    icon = "__hardCrafting__/graphics/technology/crusher_tech.png",
	icon_size = 128,
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