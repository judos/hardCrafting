require("prototypes.pulverizer")

addItem("gravel","raw-resource","g1[other]",50)
addItem("gravel-pile","raw-resource","g2[other]",50)

addRecipe("stone-brick|gravel",	"smelting","",	1.5,{{"gravel-pile",1}},		{{"stone-brick",1}},"")
addRecipe("gravel-pile",				"crafting","",	0.5,{{"gravel",4}},					{{"gravel-pile",1}},"b")

addRecipe("gravel",							"pulverizer","",4,  {{"stone",2},{"dirt",4}},{{"gravel",3}},"a")
addTechnologyUnlocksRecipe("pulverizer","gravel")