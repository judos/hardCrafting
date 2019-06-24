if settings.startup["hardcrafting-rich-ores"].value == true then
	require "prototypes.demo-resources"

	data:extend({
		{
			type = "autoplace-control",
			category = "resource",
			name = "rich-copper-ore",
			richness = true,
			order = "b"
		},
		{
			type = "item",
			icon_size = 32,
			name = "rich-copper-ore",
			icon = "__hardCrafting__/graphics/icons/rich-copper-ore.png",
			subgroup = "copper",
			order = "f[copper-ore]2",
			stack_size = 50
		},
		{
			type = "noise-layer",
			name = "rich-copper-ore"
		},
		resource("rich-copper-ore",   "b", {r=1, g=0.6, b=0.35}, 0.5, 8  )
	})

	data.raw.resource["rich-copper-ore"].minable.mining_particle = "copper-ore-particle"
	data.raw["resource"]["rich-copper-ore"].minable.results = {
		ressourceItemMinMaxProb("rich-copper-ore",	 1, 1, 0.8), -- 1 item at percentage 0.8 --
		ressourceItemMinMaxProb("gravel",				1, 1, 0.1),
		ressourceItemMinMaxProb("copper-sludge",1, 1, 0.06),
	}
end