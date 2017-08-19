require "libs.prototypes.prototypes"
require "prototypes.pulverizer"

addItem("gravel","raw-resource","g1[other]",50)
addItem("gravel-pile","raw-resource","g2[other]",50)

addRecipe("stone-brick|gravel",	"smelting","",	1.5,{{"gravel-pile",1}},		{{"stone-brick",1}},"")
addRecipe("gravel-pile",				"crafting",nil,	1.5,{{"gravel",5}},					{{"gravel-pile",1}},"b")

addRecipeCategory("hc-pulverizer")
