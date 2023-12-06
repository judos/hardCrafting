if settings.startup["hardcrafting-rich-ores"].value == true then
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
	addRecipe("copper-plate|rich","smelting","copper",9,{{"rich-copper-ore",4}},	{{"copper-plate",c(3)},{"copper-sludge",1}},"a[copper-plate]2")
	data.raw["recipe"]["copper-plate|rich"].icon = "__"..fullModName.."__/graphics/icons/copper-plate-rich.png"

	-- Tier2
	addRecipe("copper-dust|rich","crusher","copper",5,{{"rich-copper-ore",4}},{{"copper-dust",4},{"copper-sludge",1}},"b[copper-dust]2")
	data.raw["recipe"]["copper-dust|rich"].icon = "__"..fullModName.."__/graphics/icons/copper-dust-rich.png"
	addTechnologyUnlocksRecipe("crusher","copper-dust|rich")
end