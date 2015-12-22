data:extend({
  {
    type = "item",
    name = "pulverizer",
    icon = "__base__/graphics/icons/electric-furnace.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "g",
    place_result = "pulverizer",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "pulverizer",
    ingredients = {
			{"stone", 20},{"steel-plate",10},{"iron-gear-wheel",15},{"electronic-circuit",5}
		},
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
pulverizer.animation = data.raw["furnace"]["electric-furnace"].animation
pulverizer.icon = data.raw["furnace"]["electric-furnace"].icon
pulverizer.working_sound = data.raw["furnace"]["electric-furnace"].working_sound
pulverizer.open_sound  = data.raw["furnace"]["electric-furnace"].open_sound
pulverizer.close_sound  = data.raw["furnace"]["electric-furnace"].close_sound 
pulverizer.crafting_categories = {"pulverizer"}
pulverizer.energy_usage = "140kW"
pulverizer.source_inventory_size = 3
pulverizer.result_inventory_size = 3
pulverizer.crafting_speed = 1
pulverizer.minable.result = "pulverizer"
data:extend({ pulverizer })