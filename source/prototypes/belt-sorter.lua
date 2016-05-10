require "prototypes.belt-sorter-old"

-- Item
local beltSorter = deepcopy(data.raw["item"]["wooden-chest"])
overwriteContent(beltSorter, {
	name = "belt-sorter",
	order = "z[belt-sorter]",
	subgroup = "inserter",
	place_result = "belt-sorter-v2",
	icon = "__hardCrafting__/graphics/icons/belt-sorter.png",
	fuel_value = "0MJ"
})
data:extend({	beltSorter })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "belt-sorter",
		enabled = false,
		ingredients = {
			{"smart-chest", 1},
			{"steel-plate", 10},
			{"advanced-circuit", 10}
		},
		result = "belt-sorter"
	}
})

-- Entity
local beltSorter = deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(beltSorter, {
	name = "belt-sorter-v2",
	icon = "__hardCrafting__/graphics/icons/belt-sorter.png",
	energy_usage_per_tick = "50KW"
})
beltSorter.minable.result = "belt-sorter"
overwriteContent(beltSorter.picture_off, {
	filename="__hardCrafting__/graphics/entity/belt-sorter.png",
	width = 46,
	height = 33,
	shift = {0.3, 0}
})
overwriteContent(beltSorter.picture_on, {
	filename="__hardCrafting__/graphics/entity/belt-sorter.png",
	width = 46,
	height = 33,
	shift = {0.3, 0}
})
data:extend({	beltSorter })

-- fake lamp for wire connection
local beltSorterLamp = deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(beltSorterLamp, {
	name = "belt-sorter-lamp",
	order = "zzz",
	collision_box = {{0, 0}, {0, 0}},
	selection_box = {{0, 0}, {0, 0}},
	energy_usage_per_tick = "-1KW",
	energy_source = {
		type = "electric",
		usage_priority = "secondary-output"
	},
	light = nil,
	flags = {"placeable-off-grid", "not-repairable", "not-on-map"}
})
local picture = {
	filename="__hardCrafting__/graphics/entity/empty.png",
	width = 0,
	height = 0,
	shift = {0, 0}
}
overwriteContent(beltSorterLamp.picture_off, picture)
overwriteContent(beltSorterLamp.picture_on, picture)
data:extend({	beltSorterLamp })

-- Technology
data:extend({
	{
		type = "technology",
		name = "belt-sorter",
		icon = "__hardCrafting__/graphics/technology/belt-sorter.png",
		icon_size = 128,
		prerequisites = {"circuit-network","advanced-electronics" },
		effects = {},
		unit = {
			count = 50,
			ingredients = {
				{"science-pack-1", 3},
			},
			time = 15
		},
		order = "_belt-sorter"
	}
})

addTechnologyUnlocksRecipe("belt-sorter","belt-sorter")
