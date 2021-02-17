local resource_autoplace = require('resource-autoplace')

if settings.startup["hardcrafting-hard-oil"].value == true then

	data:extend({
		{
			type = "noise-layer",
			name = "oil-sand"
		},
		{
			type = "autoplace-control",
			name = "oil-sand",
			localised_name = {"", "[entity=oil-sand] ", {"entity-name.oil-sand"}},
			richness = true,
			order = "b-f",
			category = "resource",
		},
	})

	local oilSand = deepcopy(data.raw.resource["crude-oil"])
	oilSand.name = "oil-sand"
	oilSand.minable.fluid_amount = 100
	oilSand.minable.required_fluid = "fracking-fluid"
	oilSand.minable.results[1].amount_min = 20
	oilSand.minable.results[1].amount_max = 30
	oilSand.stages.sheet.filename = "__"..fullModName.."__/graphics/entity/oil-sand/oil-sand.png"

    oilSand.autoplace = resource_autoplace.resource_autoplace_settings{
		name = "oil-sand",
		order = "d", -- Other resources are "b"; oil won't get placed if something else is already there.
		base_density = 8.2,
		base_spots_per_km2 = 1.8,
		random_probability = 1/48,
		random_spot_size_minimum = 1,
		random_spot_size_maximum = 1, -- don't randomize spot size
		additional_richness = 220000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
		has_starting_area_placement = false,
		regular_rq_factor_multiplier = 1
	}

	oilSand.map_color = {r=1, g=0.84, b=0.66}
	oilSand.map_grid = true

	data:extend({oilSand})

	local frackingFluid = deepcopy(data.raw.fluid["crude-oil"])
	overwriteContent(frackingFluid,{
		name="fracking-fluid",
		base_color = {r=0.5, g=0.25, b=0},
		flow_color = {r=0.6, g=0.3, b=0.1},
		icon_size = 32,
		icon = "__"..fullModName.."__/graphics/icons/fracking-fluid.png",
	})

	data:extend({
		frackingFluid,
		{
			type = "recipe",
			name = "fracking-fluid",
			category = "oil-processing",
			enabled = false,
			energy_required = 5,
			ingredients =
			{
				{type="fluid", name="water", amount=100},
				{type="item",name="sand", amount=1},
				{type="item",name="sulfur-dust",amount=5}
			},
			results=
			{
				{type="fluid", name="fracking-fluid", amount=100},
			},
			icon = "__"..fullModName.."__/graphics/icons/fracking-fluid.png",
			icon_size = 32,
			subgroup = "fluid-recipes",
			order = "a[oil-processing]-e[fracking-fluid]"
		},
		{
			type = "technology",
			name = "oil-fracking",
			icon_size = 128,
			icon = "__base__/graphics/technology/oil-processing.png",
			prerequisites = {"oil-processing"},
			effects =
			{
				{
					type = "unlock-recipe",
					recipe = "fracking-fluid"
				},
			},
			unit =
			{
				count = 100,
				ingredients =
				{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
					{"production-science-pack", 1}
				},
				time = 30
			},
			order = "d-b"
		},


	})

end