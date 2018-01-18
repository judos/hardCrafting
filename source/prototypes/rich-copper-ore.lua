if settings.startup["hardcrafting-rich-ores"].value == true then
	-- Copy from prototypes.entity.demo-resources.lua
	local function autoplace_settings(name, coverage)
	  local ret = {
		control = name,
		sharpness = 1,
		richness_multiplier = 1500,
		richness_multiplier_distance_bonus = 20,
		richness_base = 500,
		coverage = coverage,
		starting_area_size = 600 * coverage,
		starting_area_amount = 1500,
		peaks = {
		  {
			noise_layer = name,
			noise_octaves_difference = -1.5,
			-- somehow determines how much resource is spawned (0.3 = usual for vanilla
			-- the higher the value, the less resource is spawned
			noise_persistence = 0.35, 
		  }
		}
	  }
	  return ret
	end

	function setNegativeInfluenceOnOtherResources(resource)
		for i, resource in ipairs({ "copper-ore", "iron-ore", "coal", "stone", "rich-copper-ore","rich-iron-ore" }) do
			table.insert(resource.autoplace.peaks,{
						influence = -0.99, -- Negative influence reduces value near other resource
						max_influence = 0, -- Max of 0 stops resource from generating on other resource
						noise_layer = resource, -- Noise layer determines what to avoid
						noise_octaves_difference = -2.3, -- Increased effect further from start to match irons own increase
						noise_persistence = 0.3,
					})
	  end
	end



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
			subgroup = "copper",
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
			icon_size = 32,
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
			autoplace = autoplace_settings("rich-copper-ore", 0.015),
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
end