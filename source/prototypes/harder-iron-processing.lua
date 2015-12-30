-- Requirement: --
require("prototypes.bigger-furnaces")
require("prototypes.dirt")
require("prototypes.gravel")
require("prototypes.crusher")
require("prototypes.pulverizer")

-- Minable ressources: --
data.raw["resource"]["iron-ore"].minable.result = nil
data.raw["resource"]["iron-ore"].minable.results = {
	ressourceItemMinMaxProb("iron-ore",   1, 5, 0.3), -- 1 item at percentage 0.9 --
	ressourceItemMinMaxProb("iron-nugget",1, 1, 0.1),
	ressourceItemMinMaxProb("gravel",     1, 4, 0.3),
	ressourceItemMinMaxProb("dirt",       1, 1, 1)
}

-- Item groups: --
data:extend({
  {
    type = "item-subgroup",
    name = "iron",
    group = "intermediate-products",
    order = "b2"
  }
})

-- Items: --
addItem("crushed-iron","raw-resource","e2[iron-ore]",50)
addItem("pulverized-iron","raw-resource","e3[iron-ore]",50)
addItem("iron-nugget","raw-resource","e4[iron-ore]",50)
addItem("iron-slag","raw-resource","e9[iron-ore]",50)

-- Recipes: --
data.raw["recipe"]["iron-plate"] = nil
--       item Name     category   subgroup     time    ingredients     		products
-- Tier1
addRecipe("iron-plate|nugget","smelting","iron",1,{{"iron-nugget",1}},		{{"iron-plate",1}},"a")
addRecipe("iron-plate","smelting","iron",3.5,{{"iron-ore",2}},						{{"iron-plate",1},{"iron-slag",1}},"b")
addRecipe("iron-slag","crusher","iron",8,{{"iron-slag",5}},								{{"crushed-iron",2},{"gravel",3}},"c")
addRecipe("crushed-iron","crusher","iron",16.5,{{"iron-ore",10}},					{{"crushed-iron",6},{"iron-nugget",3},{"stone",5}},"d")
-- Tier2
addRecipe("iron-plate|1","smelting","iron",		3.5,{{"crushed-iron",2}},		{{"iron-plate",2},{"iron-slag",1}},"e")
-- Tier3
addRecipe("pulverized-iron","pulverizer","iron",5.5,{{"crushed-iron",3},{"gravel",4}},	{{"pulverized-iron",3},{"iron-nugget",2},{"iron-slag",2}},"f")
addRecipe("iron-plate|2","smelting","iron",	1.75,{{"pulverized-iron",1}},	{{"iron-plate",1}},"g")