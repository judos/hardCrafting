-- Requirement: --
require "prototypes.pulverizer"

-- Minable ressources: --
data.raw["resource"]["coal"].minable.result = nil
data.raw["resource"]["coal"].minable.results = {
	ressourceItemMinMaxProb("coal", 1, 1, 0.8),
	ressourceItemMinMaxProb("coal-dust", 1, 2, 0.2)
}


-- Item: --
addItem("coal-dust","raw-resource","b[coal]2",100)
data.raw["item"]["coal-dust"].fuel_value = "2.2MJ"

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     			products		order
addRecipe("coal-dust","pulverizer","raw-material",5,{{"coal",1}},{{"coal-dust",5}},"b[coal]2")
addTechnologyUnlocksRecipe("pulverizer","coal-dust")
