-- Requirement: --
require "prototypes.crusher"
require "prototypes.harder-copper-processing"
require "prototypes.rich-copper-ore"

local function c(amount)
	return math.ceil(amount*copperOreToPlateFactor)
end

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     			products		order
-- Tier1
addRecipe("copper-plate|rich","smelting","copper",9,{{"rich-copper-ore",4}},					{{"copper-plate",c(3)},{"copper-sludge",1}},"a")

-- Tier2
addRecipe("copper-dust|rich","crusher","copper",5,{{"rich-copper-ore",4}},{{"copper-dust",4},{"copper-sludge",1}},"d")
addTechnologyUnlocksRecipe("crusher","copper-dust|rich")
