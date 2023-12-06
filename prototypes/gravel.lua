require "libs.prototypes.prototypes"
require "prototypes.pulverizer"

addItem("gravel","by-products","b[gravel]",50)
addItem("gravel-pile","by-products","c[gravel-pile]",50)

addRecipe("stone-brick|gravel",	"smelting","",	1.5,{{"gravel-pile",1}},		{{"stone-brick",1}},"a[stone-brick]b")
data.raw["recipe"]["stone-brick|gravel"].icon = "__"..fullModName.."__/graphics/icons/stone-brick-gravel.png"

addRecipe("gravel-pile", "crafting","by-products",	1.5,{{"gravel",5}},					{{"gravel-pile",1}},"c[gravel-pile]")

addRecipeCategory("hc-pulverizer")
