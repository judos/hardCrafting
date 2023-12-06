require "libs.prototypes.prototypes"
require "prototypes.dirt-tile"

-- Items: --
addItem("sand","by-products","e[sand]",50)
addItem("dirt","by-products","d[dirt]",50)

-- Place as tile: --
local placeAsTile = {
	result = "dirt-marker",
	condition_size = 3,
	condition = { "water-tile" }
}
data.raw["item"]["dirt"].place_as_tile = placeAsTile

-- Recipes: --
--       item Name     category   				subgroup     		time    ingredients    products
addRecipe("dirt-sifting","advanced-crafting","by-products",2,{{"dirt",10}},{{"gravel",2},{"sand",3},{"water",10}},"b[gravel]2")
