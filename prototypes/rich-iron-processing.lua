if settings.startup["hardcrafting-rich-ores"].value == true then
	-- Requirement: --
	require "prototypes.crusher"
	require "prototypes.harder-iron-processing"
	require "prototypes.rich-iron-ore"

	local function c(amount)
		return math.ceil(amount*ironOreToPlateFactor)
	end

	-- Recipes: --
	--       item Name     category   subgroup     time    ingredients     			products		order
	-- Tier1
	addRecipe("iron-plate|rich","smelting","iron",3.5,{{"rich-iron-ore",1}},					{{"iron-plate",c(1)},{"iron-slag",1}},"a[plate]2")
	data.raw["recipe"]["iron-plate|rich"].icon = "__"..fullModName.."__/graphics/icons/iron-plate-rich.png"

	-- Tier2
	addRecipe("crushed-iron|rich","crusher","iron",5,{{"rich-iron-ore",4}},{{"crushed-iron",4},{"iron-nugget",1}},"b[crushed-iron]2")
	data.raw["recipe"]["crushed-iron|rich"].icon = "__"..fullModName.."__/graphics/icons/crushed-iron-rich.png"
	addTechnologyUnlocksRecipe("crusher","crushed-iron|rich")
end