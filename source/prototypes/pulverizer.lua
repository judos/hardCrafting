require("prototypes.item-group-production")

data:extend({
  {
    type = "item",
	icon_size = 32,
    name = "pulverizer",
    icon = "__"..fullModName.."__/graphics/icons/pulverizer.png",
    subgroup = "advanced-processing-machine",
    order = "g",
    place_result = "pulverizer",
		enabled = false,
    stack_size = 50
  },
	{
    type = "recipe",
    name = "pulverizer",
    ingredients = {
			{"stone", 20},{"steel-plate",10},{"iron-gear-wheel",15},{"electronic-circuit",5}
		},
		enabled = false,
		energy_required = 3,
    result = "pulverizer"
  },
	{
    type = "recipe-category",
    name = "pulverizer"
  },
})

-- Entity
local pulverizer = deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
pulverizer.name = "pulverizer"
pulverizer.crafting_categories = {"pulverizer"}
pulverizer.energy_usage = "140kW"
pulverizer.source_inventory_size = 3
pulverizer.result_inventory_size = 3
pulverizer.crafting_speed = 1
pulverizer.minable.result = "pulverizer"

pulverizer.icon =  "__"..fullModName.."__/graphics/icons/pulverizer.png"

pulverizer.animation = {
  filename = "__"..fullModName.."__/graphics/entity/pulverizer-base.png",
  line_length = 1,
  width = 129,
  height = 100,
  frame_count = 1,
  axially_symmetrical = false,
  direction_count = 1,
  shift = {0.421875, 0},
}
pulverizer.working_visualisations = deepcopy(data.raw["furnace"]["electric-furnace"].working_visualisations)
table.remove(pulverizer.working_visualisations,1)
table.insert(pulverizer.working_visualisations, {animation={
	filename = "__"..fullModName.."__/graphics/entity/crush-animation.png",
	priority = "high",
	line_length = 11,
	width = 23,
	height = 14,
	frame_count = 11,
	animation_speed = 0.3,
	shift = {-0.015625, 0.9375},
}})

pulverizer.working_sound = data.raw["furnace"]["electric-furnace"].working_sound
pulverizer.open_sound  = data.raw["furnace"]["electric-furnace"].open_sound
pulverizer.close_sound  = data.raw["furnace"]["electric-furnace"].close_sound

data:extend({ pulverizer })

-- technology
data:extend({
  {
    type = "technology",
    name = "pulverizer",
    icon = "__"..fullModName.."__/graphics/technology/pulverizer.png",
    icon_size = 128,
    prerequisites = {"crusher", "advanced-material-processing" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "pulverizer"
      }
    },
    unit = {
      count = 50,
      ingredients = {
        {"automation-science-pack", 2},
				{"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "_hc_machines_2"
  }
})
