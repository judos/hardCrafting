data:extend(
{
  {
    type = "item",
    name = "fast-long-inserter",
    icon = "__hardCrafting__/graphics/icons/fast-long-inserter.png",
    flags = {"goes-to-quickbar"},
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
	icon = "__hardCrafting__/graphics/icons/fast-long-inserter.png",
	pickup_position = {0, -2},
	insert_position = {0, 2.2},
	extension_speed = 0.1
})
long.minable.result = "fast-long-inserter"
data:extend({ long })