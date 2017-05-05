require "libs.recipeCategories"
require "libs.technology"
require "prototypes.item-group-production"

-- Item and recipe
data:extend({
	{
		type = "item",
		name = "big-processing-machine",
		icon = "__hardCrafting__/graphics/icons/big-processing-machine.png",
		flags = {"goes-to-quickbar"},
		subgroup = "advanced-processing-machine",
		order = "h",
		place_result = "big-processing-machine",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "big-processing-machine",
		ingredients = {
			{"stone", 80},{"steel-plate",40},{"iron-gear-wheel",30},{"advanced-circuit",25}
		},
		energy_required = 10,
		result = "big-processing-machine"
	},
})

-- Entity
local processer = deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
overwriteContent(processer, {
	name = "big-processing-machine",
	max_health = 1500,
	crafting_categories = {"big-processing-machine"},
	energy_usage = "500kW",
	source_inventory_size = 3,
	result_inventory_size = 4,
	crafting_speed = 4,
	collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
	selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	icon =  "__hardCrafting__/graphics/icons/big-processing-machine.png",
	working_sound = data.raw["furnace"]["electric-furnace"].working_sound,
	open_sound  = data.raw["furnace"]["electric-furnace"].open_sound,
	close_sound  = data.raw["furnace"]["electric-furnace"].close_sound,
	animation = {
		filename = "__hardCrafting__/graphics/entity/big-processing-machine/big-processing-machine-base.png",
		line_length = 1,
		width = 184,
		height = 188,
		frame_count = 1,
		axially_symmetrical = false,
		direction_count = 1,
		shift = {0.515625, -0.40625},
	}
})
processer.working_visualisations = deepcopy(data.raw["furnace"]["electric-furnace"].working_visualisations)
table.remove(processer.working_visualisations,1)
processer.working_visualisations[1].animation.shift = {-1.4375, 0.328125}
processer.working_visualisations[2].animation.shift = {-0.703125, -0.890625}
table.insert(processer.working_visualisations,deepcopy(processer.working_visualisations[2]))
processer.working_visualisations[3].animation.shift = {1.078125, -1.234375}
table.insert(processer.working_visualisations, {animation={
	filename = "__hardCrafting__/graphics/entity/crush-animation.png",
	priority = "high",
	line_length = 11,
	width = 23,
	height = 14,
	frame_count = 11,
	animation_speed = 0.5,
	shift = {-0.78125, 1.90625}
}})
table.insert(processer.working_visualisations, {animation={
	filename = "__hardCrafting__/graphics/entity/wheel2.png",
	priority = "high",
	line_length = 4,
	width = 33,
	height = 25,
	frame_count = 4,
	animation_speed = 0.5,
	shift = {1.1875, 0.859375}
}})

processer.fluid_boxes = {}
table.insert(processer.fluid_boxes,{
	production_type = "input",
	pipe_picture = assembler2pipepictures(),
	pipe_covers = pipecoverspictures(),
	base_area = 10,
	base_level = -1,
	pipe_connections = {{ type="input", position = {0, -3} }}
})
table.insert(processer.fluid_boxes,{
	production_type = "output",
	pipe_picture = assembler2pipepictures(),
	pipe_covers = pipecoverspictures(),
	base_area = 10,
	base_level = 1,
	pipe_connections = {{ type="output", position = {0, 3} }}
})
processer.fluid_boxes[1].pipe_picture.north.filename = "__hardCrafting__/graphics/entity/big-processing-machine/pipe-north.png"
processer.fluid_boxes[2].pipe_picture.north.filename = "__hardCrafting__/graphics/entity/big-processing-machine/pipe-north.png"
processer.minable.result = "big-processing-machine"

data:extend({ processer })

-- technology
data:extend({
	{
		type = "technology",
		name = "big-processing-machine",
		icon = "__hardCrafting__/graphics/technology/big-processing-machine.png",
		icon_size = 128,
		prerequisites = { "pulverizer", "advanced-electronics"},
		unit = {
			count = 250,
			ingredients = {
				{"science-pack-1", 5},
				{"science-pack-2", 2},
				{"science-pack-3", 1}
			},
			time = 30
		},
		order = "_hc_machines_3"
	}
})
addTechnologyUnlocksRecipe("big-processing-machine", "big-processing-machine")

-- Copy recipes for processing machine
addRecipeCategory("big-processing-machine")
local m1 = {
	ingredients={ {type="fluid",name="water",amount=1} },
	results={ {type="item",name="dirt",amount=1} }
}
local recipes = {["iron-slag"]=m1, ["crushed-iron"]=m1, ["pulverized-iron"]=m1,
	["copper-sludge"]=m1, ["copper-dust"]=m1, ["copper-plate|sulfat"]=m1}

for name,mod in pairs(recipes) do
	local recipe = deepcopy(data.raw.recipe[name])
	recipe.name = recipe.name .. "-big"
	recipe.order = recipe.order .. "2"
	recipe.category = "big-processing-machine"
	if name == "crushed-iron" then
		recipe.energy_required = 11
	end

	for _,item in pairs(mod.ingredients) do
		recipeAddIngredient(recipe,item)
	end
	for _,item in pairs(mod.results) do
		table.insert(recipe.results,item)
	end
	data:extend({recipe})
	addTechnologyUnlocksRecipe("big-processing-machine", recipe.name)
end

addRecipe("dried-dirt|big","big-processing-machine","raw-resource",	7,{{"dirt",10}},		{{"dried-dirt",2},{"water",1}},"g3[other")
addTechnologyUnlocksRecipe("big-processing-machine", "dried-dirt|big")
