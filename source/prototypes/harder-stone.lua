-- Requirement: --
require "prototypes.crusher"

-- Minable ressources: --
data.raw["resource"]["stone"].minable.result = nil
data.raw["resource"]["stone"].minable.results = {
	ressourceItemMinMaxProb("stone", 1, 1, 0.9),
	ressourceItemMinMaxProb("gravel", 1, 2, 0.2)
}

-- Recipes: --
--       item Name     category   subgroup     time   							 ingredients     products		order
data.raw["recipe"]["stone-brick"] = nil
addRecipe("stone-brick","crusher","terrain",2,{{"stone",2}},{{"stone-brick",2},{"gravel",1}},"b[coal]2")
data.raw["recipe"]["stone-brick"].icon = "__"..fullModName.."__/graphics/icons/stone-brick.png"
addTechnologyUnlocksRecipe("crusher","stone-brick")

addRecipe("gravel|pulverizer","pulverizer","raw-resource",1,{{"stone",1}},{{"gravel",2}},"b[coal]2")
data.raw["recipe"]["gravel|pulverizer"].icon = "__"..fullModName.."__/graphics/icons/gravel-pulverizer.png"
addTechnologyUnlocksRecipe("pulverizer","gravel|pulverizer")
