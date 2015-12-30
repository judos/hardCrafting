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
    result = "crusher"
  },
	{
    type = "recipe-category",
    name = "crusher"
  },
})

-- Entity
local crusher = deepcopy(data.raw["furnace"]["electric-furnace"])
crusher.name = "crusher"
crusher.icon =  "__hardCrafting__/graphics/icons/crusher.png"
crusher.crafting_categories = {"crusher"}
crusher.energy_usage = "80kW"
crusher.minable.result = "crusher"
crusher.source_inventory_size = 1
crusher.result_inventory_size = 3
crusher.crafting_speed = 1
crusher.animation.filename="__hardCrafting__/graphics/entity/crusher/crusher-base.png"
crusher.working_visualisations[1] = {
	animation =
	{
		filename = "__hardCrafting__/graphics/entity/crusher/crusher-gears.png",
		priority = "high",
		width = 25,
		height = 15,
		frame_count = 4,
		animation_speed = 0.2,
		shift = {0.015625, 0.890625}
	},
	light = {intensity = 0.4, size = 6, shift = {0.0, 1.0}}
}
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
    order = "crusher"
  }
})