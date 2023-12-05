require "libs.prototypes.prototypes"
require "libs.prototypes.technology"
require "prototypes.item-group-production"

-- Item and recipe
data:extend({
	{
		type = "item",
		icon_size = 32,
		name = "big-processing-machine",
		icon = "__"..fullModName.."__/graphics/icons/big-processing-machine.png",
		subgroup = "advanced-processing-machine",
		order = "h",
		place_result = "big-processing-machine",
		stack_size = 50
	},
	{
		type = "recipe",
		name = "big-processing-machine",
		ingredients = {
			{"crusher", 2},{"pulverizer",2},{"steel-plate",20},{"advanced-circuit",20}
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
	energy_usage = "400kW",
	source_inventory_size = 3,
	result_inventory_size = 4,
	crafting_speed = 4,
	collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
	selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	icon =  "__"..fullModName.."__/graphics/icons/big-processing-machine.png",
	icon_size = 32,
	working_sound = data.raw["furnace"]["electric-furnace"].working_sound,
	open_sound  = data.raw["furnace"]["electric-furnace"].open_sound,
	close_sound  = data.raw["furnace"]["electric-furnace"].close_sound,
	animation = {
		filename = "__"..fullModName.."__/graphics/entity/big-processing-machine/big-processing-machine-base.png",
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
	filename = "__"..fullModName.."__/graphics/entity/crush-animation.png",
	priority = "high",
	line_length = 11,
	width = 23,
	height = 14,
	frame_count = 11,
	animation_speed = 0.5,
	shift = {-0.78125, 1.90625}
}})
table.insert(processer.working_visualisations, {animation={
	filename = "__"..fullModName.."__/graphics/entity/wheel2.png",
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
processer.fluid_boxes[1].pipe_picture.north.filename = "__"..fullModName.."__/graphics/entity/big-processing-machine/pipe-north.png"
processer.fluid_boxes[2].pipe_picture.north.filename = "__"..fullModName.."__/graphics/entity/big-processing-machine/pipe-north.png"
processer.minable.result = "big-processing-machine"
processer.fast_replaceable_group = nil
processer.next_upgrade = nil
processer.module_specification.module_slots = 4

data:extend({ processer })

-- technology
data:extend({
	{
		type = "technology",
		name = "big-processing-machine",
		icon = "__"..fullModName.."__/graphics/technology/big-processing-machine.png",
		icon_size = 128,
		prerequisites = { "pulverizer", "advanced-electronics"},
		unit = {
			count = 500,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1}
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
	ingredients={ {type="fluid",name="water",amount=10} },
	results={ {type="item",name="dirt",amount=1} }
}
local recipes = {}
if settings.startup["hardcrafting-rich-ores"].value == true then
	recipes = {["iron-slag"]=m1, ["crushed-iron"]=m1, ["crushed-iron|rich"]=m1, ["pulverized-iron"]=m1,
	["copper-sludge"]=m1, ["copper-dust"]=m1, ["copper-dust|rich"]=m1, ["copper-plate|sulfat"]=m1}
else
	recipes = {["iron-slag"]=m1, ["crushed-iron"]=m1, ["pulverized-iron"]=m1,
	["copper-sludge"]=m1, ["copper-dust"]=m1, ["copper-plate|sulfat"]=m1}
end

for name,mod in pairs(recipes) do
	local recipe = deepcopy(data.raw.recipe[name])
	recipe.name = recipe.name .. "-big"
	recipe.order = recipe.order .. "2"
	recipe.category = "big-processing-machine"
	recipe.icon = recipe.icon:gsub(".png$", "-big.png")
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

