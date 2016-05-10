require "libs.recipeCategories"
require "prototypes.item-group-production"

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
})

-- Entity
local processer = deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
overwriteContent(processer, {
	name = "big-processing-machine",
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
		filename = "__hardCrafting__/graphics/entity/big-processing-machine/big-processing-machine.png",
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
processer.fluid_boxes[1].pipe_picture.north.filename = "__hardCrafting__/graphics/entity/big-processing-machine/pipe-north.png"
processer.fluid_boxes[2].pipe_picture.north.filename = "__hardCrafting__/graphics/entity/big-processing-machine/pipe-north.png"
processer.minable.result = "big-processing-machine"

data:extend({ processer })

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
	recipe.enabled = true
	recipe.order = recipe.order .. "2"
	recipe.category = "big-processing-machine"
	
	for _,item in pairs(mod.ingredients) do
		recipeAddIngredient(recipe,item)
	end
	for _,item in pairs(mod.results) do
		table.insert(recipe.results,item)
	end
	data:extend({recipe})
end
