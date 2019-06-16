if settings.startup["hardcrafting-rich-ores"].value == true then
	require "prototypes.demo-resources"
	
	data:extend({
		{
			type = "autoplace-control",
			name = "rich-iron-ore",
			richness = true,
			order = "b-a",
			category = "resource",
		},
		{
			type = "item",
			icon_size = 32,
			name = "rich-iron-ore",
			icon = "__hardCrafting__/graphics/icons/rich-iron-ore.png",
			flags = {"goes-to-main-inventory"},
			subgroup = "iron",
			order = "e[iron-ore]2",
			stack_size = 50
		},
		{
			type = "noise-layer",
			name = "rich-iron-ore"
		},
		resource("rich-iron-ore",   "d", {r=0.47, g=0.52, b=0.7}, 0.5, richness_iron_ore/4  )
	})
	
	local autoplace = data.raw.resource["rich-iron-ore"].autoplace
	autoplace.starting_area_size = 5*autoplace.starting_area_size
	autoplace.starting_area_amount = 1*autoplace.starting_area_amount
	data.raw.resource["rich-iron-ore"].minable.mining_particle = "iron-ore-particle"
	data.raw.resource["rich-iron-ore"].minable.results = {
		ressourceItemMinMaxProb("rich-iron-ore", 	1, 2, 0.6),
		ressourceItemMinMaxProb("iron-slag",			1, 1, 0.1),
		ressourceItemMinMaxProb("iron-nugget",			1, 1, 0.2)
	}
end