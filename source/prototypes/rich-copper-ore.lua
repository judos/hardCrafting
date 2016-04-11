data:extend({
	{
		type = "autoplace-control",
		name = "rich-copper-ore",
		richness = true,
		order = "b-a"
	},
	{
		type = "item",
		name = "rich-copper-ore",
		icon = "__hardCrafting__/graphics/icons/rich-copper-ore.png",
		flags = {"goes-to-main-inventory"},
		subgroup = "raw-resource",
		order = "f[copper-ore]2",
		stack_size = 50
	},
	{
		type = "noise-layer",
		name = "rich-copper-ore"
	},
	{
		type = "resource",
		name = "rich-copper-ore",
		icon = "__hardCrafting__/graphics/icons/rich-copper-ore.png",
		flags = {"placeable-neutral"},
		order="a-b-a",
		minable =
		{
			hardness = 0.7,
			mining_particle = "copper-ore-particle",
			mining_time = 1.5,
			results = {} -- see below
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace =
		{
			control = "rich-copper-ore",
			sharpness = 1,
			max_probability = 1,
			richness_multiplier = 10000,
			richness_base = 500,
			size_control_multiplier = 0.1,
			peaks = {
				{
					influence = 0.6, -- the bigger the more likely an ore field will generate (also with higher richness)
					noise_layer = "rich-copper-ore", -- uses a randomly generated noise layer
					noise_octaves_difference = -2, -- smaller = fine grained ore patches
					noise_persistence = 0.2,
					starting_area_weight_optimal = 1,
					starting_area_weight_range = 0,
					starting_area_weight_max_range = 2,
				},
				{ -- influence near spawn
					influence = 0.4,
					starting_area_weight_optimal = 1,
					starting_area_weight_range = 0,
					starting_area_weight_max_range = 2,
				},
				{
					influence = -0.99, -- Negative influence reduces value near iron
					max_influence = 0, -- Max of 0 stops copper from generating on iron
					noise_layer = "iron-ore", -- Noise layer determines what to avoid
					noise_octaves_difference = -2.3, -- Increased effect further from start to match irons own increase
					noise_persistence = 0.45,
				},
				{
					influence = -0.99, -- Negative influence reduces value near iron
					max_influence = 0, -- Max of 0 stops copper from generating on iron
					noise_layer = "copper-ore", -- Noise layer determines what to avoid
					noise_octaves_difference = -2.3, -- Increased effect further from start to match irons own increase
					noise_persistence = 0.45,
				},
				{
					influence = -0.99, -- Negative influence reduces value near iron
					max_influence = 0, -- Max of 0 stops copper from generating on iron
					noise_layer = "coal", -- Noise layer determines what to avoid
					noise_octaves_difference = -2.3, -- Increased effect further from start to match irons own increase
					noise_persistence = 0.45,
				},
				{
					influence = -0.99, -- Negative influence reduces value near iron
					max_influence = 0, -- Max of 0 stops copper from generating on iron
					noise_layer = "stone", -- Noise layer determines what to avoid
					noise_octaves_difference = -2.3, -- Increased effect further from start to match irons own increase
					noise_persistence = 0.45,
				}
				--[[
				{ -- influence near spawn
					influence = 0.5,
					starting_area_weight_optimal = 1,
					starting_area_weight_range = 0,
					starting_area_weight_max_range = 2,
				},
				{ -- increased influence the further away from spawn
					influence = 0.5,
					starting_area_weight_optimal = 0,
					starting_area_weight_range = 0,
					starting_area_weight_max_range = 2,
				},
			 ]]--
			},
		},
		stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
		stages =
		{
			sheet =
			{
				filename = "__hardCrafting__/graphics/resources/rich-copper-ore.png",
				priority = "extra-high",
				width = 38,
				height = 38,
				frame_count = 4,
				variation_count = 8
			}
		},
		map_color = {r=1, g=0.6, b=0.35}
	},
})


data.raw["resource"]["rich-copper-ore"].minable.results = {
	ressourceItemMinMaxProb("rich-copper-ore",	 1, 1, 0.8), -- 1 item at percentage 0.8 --
	ressourceItemMinMaxProb("gravel",				1, 1, 0.1),
	ressourceItemMinMaxProb("copper-sludge",1, 1, 0.06),
}