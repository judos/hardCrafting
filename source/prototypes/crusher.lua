require("prototypes.item-group-production")

data:extend({
	{
		type = "item",
		icon_size = 32,
		name = "crusher",
		icon = "__"..fullModName.."__/graphics/icons/crusher.png",
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

crusher.icon =  "__"..fullModName.."__/graphics/icons/crusher.png"
crusher.animation = {
	filename = "__"..fullModName.."__/graphics/entity/crusher-base.png",
	line_length = 1,
	width = 129,
	height = 100,
	frame_count = 1,
	axially_symmetrical = false,
	direction_count = 1,
	shift = {0.421875, 0},
}
crusher.working_visualisations = deepcopy(data.raw["furnace"]["electric-furnace"].working_visualisations)
table.remove(crusher.working_visualisations,1)
table.insert(crusher.working_visualisations, {animation={
	filename = "__"..fullModName.."__/graphics/entity/crush-animation.png",
	priority = "high",
	line_length = 11,
	width = 23,
	height = 14,
	frame_count = 11,
	animation_speed = 0.2,
	shift = {-0.015625, 0.9375},
}})

crusher.working_sound = data.raw["furnace"]["electric-furnace"].working_sound
crusher.open_sound  = data.raw["furnace"]["electric-furnace"].open_sound
crusher.close_sound  = data.raw["furnace"]["electric-furnace"].close_sound

data:extend({ crusher })

-- technology
data:extend({
	{
		type = "technology",
		name = "crusher",
		icon = "__"..fullModName.."__/graphics/technology/crusher.png",
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
				{"automation-science-pack", 1}
			},
			time = 20
		},
		order = "_hc_machines_1"
	}
})
