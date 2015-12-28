-- Requirement: --
require("prototypes.bigger-furnaces")
require("prototypes.dirt")
require("prototypes.gravel")

-- Minable ressources: --
data.raw["resource"]["copper-ore"].minable.result = nil
data.raw["resource"]["copper-ore"].minable.results = {
	ressourceItemMinMaxProb("copper-ore",   1, 3, 0.375), -- 1 item at percentage 0.75 --
	ressourceItemMinMaxProb("gravel",       1, 3, 0.4),
	ressourceItemMinMaxProb("copper-sludge",1, 1, 0.4),
	ressourceItemMinMaxProb("dirt",         1, 1, 1)
}

-- Item groups: --
data:extend({
  {
    type = "item-subgroup",
    name = "copper",
    group = "intermediate-products",
    order = "b3"
  }
})

-- Items: --
addItem("copper-sulfat","raw-resource","f2[copper-ore]",50)
addItem("copper-dust","raw-resource","f3[copper-ore]",50)
addItem("copper-sludge","raw-resource","f4[copper-ore]",50)

addItem("sulfur-dust","raw-resource","f5[copper-ore]",50)

-- Recipes: --
data.raw["recipe"]["copper-plate"] = nil
--       item Name     category   subgroup     time    ingredients     			products		order
-- Tier1
addRecipe("copper-plate","smelting","copper",6,{{"copper-ore",3}},					{{"copper-plate",1},{"copper-sludge",2}},"a")
addRecipe("copper-sludge","crusher","copper",4,{{"copper-sludge",2}},			{{"copper-dust",1},{"gravel",1}},"b")
addRecipe("copper-plate|dust","smelting","copper",1.75,{{"copper-dust",1}},	{{"copper-plate",1}},"c")

-- Tier2
addRecipe("copper-dust","pulverizer","copper",6,{{"copper-ore",4},{"gravel",3}},{{"copper-dust",4},{"sulfur-dust",2}},"d")
addRecipe("sulfur|dust","crafting","copper",2,{{"sulfur-dust",25}},{{"sulfur",1}},"e")

-- Tier3
addRecipe("copper-sulfat","crafting","copper",2,{{"copper-dust",9},{"sulfur-dust",5}},{{"copper-sulfat",10}},"f")
addRecipe("copper-plate|sulfat","chemistry","copper",2,
	{{type="item",name="copper-sulfat",amount=6},{type="fluid",name="water",amount=1}},
	{{"copper-plate",7},{"sulfuric-acid",0.5},{"gravel",1}},"g")

--[[
addRecipe("iron-plate","smelting","iron",3.5,{{"iron-ore",2}},						{{"iron-plate",1},{"iron-slag",1}},"b")
addRecipe("iron-slag","crusher","iron",8,{{"iron-slag",5}},								{{"crushed-iron",2},{"gravel",3}},"c")
addRecipe("crushed-iron","crusher","iron",16.5,{{"iron-ore",10}},					{{"crushed-iron",6},{"iron-nugget",3},{"stone",5}},"d")
addRecipe("iron-plate|1","smelting","iron",		3.5,{{"crushed-iron",2}},		{{"iron-plate",2},{"iron-slag",1}},"e")
-- Tier3
addRecipe("pulverized-iron","pulverizer","iron",5.5,{{"crushed-iron",3},{"gravel",4}},	{{"pulverized-iron",3},{"iron-nugget",2},{"iron-slag",2}},"f")
addRecipe("iron-plate|2","smelting","iron",	1.75,{{"pulverized-iron",1}},	{{"iron-plate",1}},"g")
addRecipe("gravel","pulverizer",	"iron",			4,{{"stone",2},{"dirt",4}},	{{"gravel",3}})
]]--