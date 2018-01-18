if settings.startup["hardcrafting-extra-inserters"].value == true then
	data:extend(
	{
	  {
		type = "item",
		name = "long-filter-inserter",
		icon = "__hardCrafting__/graphics/icons/long-filter-inserter.png",
		icon_size = 32,
		flags = {"goes-to-quickbar"},
		subgroup = "inserter",
		order = "f[inserter]-e[smart-inserter]-2",
		place_result = "long-filter-inserter",
		stack_size = 50
	  },
		{
		type = "recipe",
		name = "long-filter-inserter",
		enabled = "false",
		ingredients =
		{
				{"electronic-circuit", 4},
		  {"iron-plate", 2},
		  {"fast-inserter", 1}
		},
		result = "long-filter-inserter"
	  }
	})

	addTechnologyUnlocksRecipe("logistics-2","long-filter-inserter")

	local long = deepcopy(data.raw["inserter"]["filter-inserter"])
	overwriteContent(long, {
		name = "long-filter-inserter",
		icon = "__hardCrafting__/graphics/icons/long-filter-inserter.png",
		pickup_position = {0, -2},
		insert_position = {0, 2.2},
		extension_speed = 0.1
	})
	long.minable.result = "long-filter-inserter"
	data:extend({ long })
end