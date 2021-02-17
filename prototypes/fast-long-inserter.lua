require "libs.prototypes.technology"

if settings.startup["hardcrafting-extra-inserters"].value == true then
	data:extend(
	{
	  {
		type = "item",
		name = "fast-long-inserter",
		icon = "__"..fullModName.."__/graphics/icons/fast-long-inserter.png",
		icon_size = 32,
		subgroup = "inserter",
		order = "d[fast-inserter]-2",
		place_result = "fast-long-inserter",
		stack_size = 50
	  },
		{
		type = "recipe",
		name = "fast-long-inserter",
		enabled = "false",
		ingredients =
		{
				{"electronic-circuit", 2},
		  {"iron-gear-wheel", 1},
		  {"iron-plate", 2},
		  {"inserter", 1}
		},
		result = "fast-long-inserter"
	  }
	})

	addTechnologyUnlocksRecipe("logistics-2","fast-long-inserter")

	local long = deepcopy(data.raw["inserter"]["fast-inserter"])
	overwriteContent(long, {
		name = "fast-long-inserter",
		icon = "__"..fullModName.."__/graphics/icons/fast-long-inserter.png",
		icon_size = 32,
		pickup_position = {0, -2},
		insert_position = {0, 2.2},
		extension_speed = 0.1
	})
	long.minable.result = "fast-long-inserter"
	data:extend({ long })
end