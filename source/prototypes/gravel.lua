addItem("gravel","raw-resource","g[other]",50)
addItem("gravel-pile","raw-resource","g2[other]",50)

addRecipe("stone-brick|gravel","smelting","",1.5,{{"gravel-pile",1}},	{{"stone-brick",1}},"")
addRecipe("gravel-pile","crafting","",0.5,{{"gravel",2}},	{{"gravel-pile",1}},"")