
if settings.startup["hardcrafting-hard-oil"].value == true then


	local oilSand = deepcopy(data.raw.resource["crude-oil"])
	oilSand.name = "oil-sand"
	oilSand.minable.fluid_amount = 100
	oilSand.minable.required_fluid = "fracking-fluid"
	oilSand.minable.results[1].amount_min = 20
	oilSand.minable.results[1].amount_max = 30
	oilSand.stages.sheet.filename = "__hardCrafting__/graphics/entity/oil-sand/oil-sand.png"
	oilSand.autoplace.control = "oil-sand"
	oilSand.autoplace.coverage = 0.001 / 3 * 5--3x crude-oil
	oilSand.autoplace.peaks = {
		{
			noise_layer = "oil-sand",
			noise_octaves_difference = -0.25,
			noise_persistence = 0.4,
		}
	}
	oilSand.map_color = {r=1, g=0.84, b=0.66}
	oilSand.map_grid = true
	
	data:extend({
		oilSand,
	  {
			type = "noise-layer",
			name = "oil-sand"
		},
		{
			type = "autoplace-control",
			name = "oil-sand",
			richness = true,
			order = "b-f",
			category = "resource",
		},
	})
	
	local frackingFluid = deepcopy(data.raw.fluid["crude-oil"])
	overwriteContent(frackingFluid,{
		name="fracking-fluid",
		base_color = {r=0.5, g=0.25, b=0},
		flow_color = {r=0.6, g=0.3, b=0.1},
		icon = "__hardCrafting__/graphics/icons/fracking-fluid.png",
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
			icon = "__hardCrafting__/graphics/icons/fracking-fluid.png",
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
					{"science-pack-1", 1},
					{"science-pack-2", 1},
					{"science-pack-3", 1},
					{"production-science-pack", 1}
				},
				time = 30
			},
			order = "d-b"
		},
		
		
	})
	
end