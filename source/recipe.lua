data.raw["furnace"]["stone-furnace"].result_inventory_size = 2
data.raw["furnace"]["steel-furnace"].result_inventory_size = 2
data.raw["furnace"]["electric-furnace"].result_inventory_size = 2


data:extend({
  {
    type = "item-subgroup",
    name = "iron",
    group = "intermediate-products",
    order = "b2"
  }
	})



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
addRecipe("gravel","pulverizer",	"iron",			4,{{"stone",2},{"dirt",4}},	{{"gravel",3}})