local dirt_vehicle_speed_modifier = 100
local dirt_walking_speed_modifier = 0.9

require "prototypes.dirt-tile"

-- Items: --
addItem("dried-dirt","raw-resource","g4[other]",50)
addItem("dirt","raw-resource","g3[other]",50)

-- Place as tile: --
local placeAsTile = {
	result = "dirt-marker",
	condition_size = 3,
	condition = { "water-tile" }
}
data.raw["item"]["dirt"].place_as_tile = placeAsTile
data.raw["item"]["dried-dirt"].place_as_tile = placeAsTile

-- Recipes: --
--       item Name     category   				subgroup     		time    ingredients    products
addRecipe("dried-dirt","advanced-crafting","raw-resource",	3.5,{{"dirt",5}},		{{"dried-dirt",2},{"water",1}},"g3[other")
