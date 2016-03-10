require "find-raw-ingredients"

-- Item: --
addItem("steel-dust","raw-material","d1[steel-plate]",50)


-- Calculate ore->plate factor for Recipes
local ironPlateUsed = findRawIngredient("steel-plate","iron-plate")
info(tostring(ironPlateUsed).."x Iron-plate = 1x Steel-plate")
local benefit = 0.2 -- 20% less iron-plates useed
local cost = math.floor(ironPlateUsed * (1-0.2))

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     		products
addRecipe("steel-dust","crafting","raw-material",3,{{"iron-plate",cost},{"coal-dust",1}},		{{"steel-dust",1}},"d2[steel-plate]")
addRecipe("steel-plate|dust","smelting","raw-material",3,{{"steel-dust",1}},		{{"steel-plate",1}},"d3[steel-plate]")

-- technology
data:extend({
	{
		type = "technology",
		name = "steel-processing-2",
		icon = "__base__/graphics/technology/steel-processing.png",
		prerequisites = {"steel-processing"},
		effects = {},
		unit = {
			count = 30,
			ingredients = {{"science-pack-1", 2}},
			time = 30
		},
		order = "_steel-processing-2"
	}
})

addTechnologyUnlocksRecipe("steel-processing-2", "steel-dust")
addTechnologyUnlocksRecipe("steel-processing-2", "steel-plate|dust")
