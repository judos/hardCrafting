-- Item: --
addItem("steel-dust","iron","e[iron-ore]7",50)

-- Calculate ore->plate factor for Recipes
local ironPlateUsed = findRawIngredient("steel-plate","iron-plate")
info(tostring(ironPlateUsed).."x Iron-plate = 1x Steel-plate")
local benefit = 0.2 -- 20% less iron-plates useed
local cost = math.floor(ironPlateUsed * (1-benefit) / ironOreToPlateFactor)
if cost<1 then cost = 1 end -- Beware of rounding down to zero

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     		products
addRecipe("steel-dust","crafting","iron",3,{{"crushed-iron",cost},{"coal-dust",2}},		{{"steel-dust",1}},"d2[steel-plate]")
data.raw["recipe"]["steel-dust"].icon = "__"..fullModName.."__/graphics/icons/steel-dust-crushed.png"

addRecipe("steel-dust|2","crafting","iron",2,{{"pulverized-iron",cost},{"coal-dust",1}},		{{"steel-dust",1}},"d2[steel-plate]")
data.raw["recipe"]["steel-dust|2"].icon = "__"..fullModName.."__/graphics/icons/steel-dust-pulverized.png"

addRecipe("steel-plate|dust","smelting","raw-material",8,{{"steel-dust",1}},		{{"steel-plate",1}},"d3[steel-plate]")
data.raw["recipe"]["steel-plate|dust"].icon = "__"..fullModName.."__/graphics/icons/steel-plate-dust.png"

-- technology
data:extend({
	{
		type = "technology",
		icon_size = 256, icon_mipmaps = 4,
		name = "steel-processing-2",
		icon = "__base__/graphics/technology/steel-processing.png",
		prerequisites = {"steel-processing"},
		effects = {},
		unit = {
			count = 30,
			ingredients = {{"automation-science-pack", 2}},
			time = 30
		},
		order = "_steel-processing-2"
	}
})

addTechnologyUnlocksRecipe("steel-processing-2", "steel-dust")
addTechnologyUnlocksRecipe("steel-processing-2", "steel-dust|2")
addTechnologyUnlocksRecipe("steel-processing-2", "steel-plate|dust")
