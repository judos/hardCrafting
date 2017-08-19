require "libs.recipeCategories"
require "prototypes.dirt-tile"

-- Items: --
addItem("sand","raw-resource","g4[other]",50)
addItem("dirt","raw-resource","g3[other]",50)

-- Place as tile: --
local placeAsTile = {
	result = "dirt-marker",
	condition_size = 3,
	condition = { "water-tile" }
}
data.raw["item"]["dirt"].place_as_tile = placeAsTile

-- Recipes: --
--       item Name     category   				subgroup     		time    ingredients    products
addRecipe("dirt-sifting","advanced-crafting","raw-resource",2,{{"dirt",10}},{{"gravel",2},{"sand",3},{type="fluid", name="water", amount=10}},"g3[other")
