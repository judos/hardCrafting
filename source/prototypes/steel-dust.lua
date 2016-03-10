require "find-raw-ingredients"

-- Item: --
addItem("steel-dust","raw-resource","f1[steel-dust]",50)



-- Calculate ore->plate factor for Recipes
local ironPlateUsed = findRawIngredient("steel-plate","iron-plate")

info("Iron plate to steel factor: "..tostring(ironPlateUsed).."->1")

local benefit = 0.2 -- 20% less iron-plates useed

local cost = math.floor(ironPlateUsed * (1-0.2))


-- Recipes: --
--       item Name     category   subgroup     time    ingredients     		products
addRecipe("steel-dust","crafting","raw-resource",3,{{"iron-plate",cost},{"coal-dust",1}},		{{"steel-dust",1}},"f1[steel]")
addRecipe("steel-plate|dust","smelting","raw-resource",3,{{"steel-dust",1}},		{{"steel-plate",1}},"f2[steel]")