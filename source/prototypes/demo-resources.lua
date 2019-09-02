resource_autoplace.initialize_patch_set("oil-sand", false)

local function autoplace_settings(name, order, coverage)
	return
	{
		order = order,
		control = name,
		sharpness = 15/16,
		richness_multiplier = 1500,
		richness_multiplier_distance_bonus = 20,
		richness_base = 10,
		coverage = coverage,
		peaks =
		{
			{
				noise_layer = name,
				noise_octaves_difference = -0.85,
				noise_persistence = 0.4
			}
		},
		starting_area_size = 5500 * coverage,
		starting_area_amount = 1600
	}
end


function resource(resource_parameters, autoplace_parameters)
	if coverage == nil then coverage = 0.02 end

	return
	{
		type = "resource",
		name = resource_parameters.name,
		icon = "__" ..fullModName.. "__/graphics/icons/" .. resource_parameters.name .. ".png",
		icon_size = 32,
		flags = {"placeable-neutral"},
		order="a-b-"..resource_parameters.order,
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
			mining_particle = resource_parameters.name .. "-particle",
			mining_time = resource_parameters.mining_time,
			result = resource_parameters.name
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		-- autoplace = autoplace_settings(name, order, coverage),
		autoplace = resource_autoplace.resource_autoplace_settings{
			name = resource_parameters.name,
			order = resource_parameters.order,
			base_density = autoplace_parameters.base_density,
			has_starting_area_placement = true,
			regular_rq_factor_multiplier = autoplace_parameters.regular_rq_factor_multiplier;
			starting_rq_factor_multiplier = autoplace_parameters.starting_rq_factor_multiplier;
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
			sheet =
			{
				filename = "__"..fullModName.."__/graphics/entity/" .. resource_parameters.name .. "/" .. resource_parameters.name .. ".png",
				priority = "extra-high",
				size = 64,
				frame_count = 8,
				variation_count = 8,
				hr_version =
				{
					filename = "__"..fullModName.."__/graphics/entity/" .. resource_parameters.name .. "/hr-" .. resource_parameters.name .. ".png",
					priority = "extra-high",
					size = 128,
					frame_count = 8,
					variation_count = 8,
					scale = 0.5
				}
			}
		},
		map_color = resource_parameters.map_color
	}
end

