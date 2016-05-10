require("prototypes.item-group-production")

data:extend({
	{
		type = "item",
		name = "big-processing-machine",
		icon = "__hardCrafting__/graphics/icons/big-processing-machine.png",
		flags = {"goes-to-quickbar"},
		subgroup = "advanced-processing-machine",
		order = "h",
		place_result = "big-processing-machine",
		enabled = false,
		stack_size = 50
	},
	{
		type = "recipe",
		name = "big-processing-machine",
		ingredients = {
			{"stone", 80},{"steel-plate",40},{"iron-gear-wheel",30},{"advanced-circuit",25}
		},
		enabled = true,
		result = "big-processing-machine"
	},
	{
    type = "recipe-category",
    name = "big-processing-machine"
  }
})

-- Entity
local processer = deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
overwriteContent(processer, {
	name = "big-processing-machine",
	crafting_categories = {"pulverizer","crusher","big-processing-machine"},
	energy_usage = "500kW",
	source_inventory_size = 3,
	result_inventory_size = 3,
	crafting_speed = 3,
	collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
	selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	icon =  "__hardCrafting__/graphics/icons/big-processing-machine.png",
	working_sound = data.raw["furnace"]["electric-furnace"].working_sound,
	open_sound  = data.raw["furnace"]["electric-furnace"].open_sound,
	close_sound  = data.raw["furnace"]["electric-furnace"].close_sound,
	animation = {
		filename = "__hardCrafting__/graphics/entity/big-processing-machine.png",
		priority = "high",
		width = 185,
		height = 143,
		frame_count = 1,
		line_length = 1,
		shift = {0.5, -0.06}
	}
})
processer.fluid_boxes[1].pipe_connections[1].position = {0,-3}
processer.fluid_boxes[2].pipe_connections[1].position = {0,3}
processer.minable.result = "big-processing-machine"

data:extend({ processer })
