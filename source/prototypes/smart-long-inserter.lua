data:extend(
{
  {
    type = "item",
    name = "smart-long-inserter",
    icon = "__hardCrafting__/graphics/icons/smart-long-inserter.png",
    flags = {"goes-to-quickbar"},
    subgroup = "inserter",
    order = "f[inserter]-e[smart-inserter]-2",
    place_result = "smart-long-inserter",
    stack_size = 50
  },
	{
    type = "recipe",
    name = "smart-long-inserter",
    enabled = "false",
    ingredients =
    {
			{"electronic-circuit", 4},
      {"iron-plate", 2},
      {"fast-inserter", 1}
    },
    result = "smart-long-inserter"
  }
})

addTechnologyUnlocksRecipe("logistics-2","smart-long-inserter")

local long = deepcopy(data.raw["inserter"]["smart-inserter"])
overwriteContent(long, {
	name = "smart-long-inserter",
	icon = "__hardCrafting__/graphics/icons/smart-long-inserter.png",
	pickup_position = {0, -2},
	insert_position = {0, 2.2},
	extension_speed = 0.1
})
long.minable.result = "smart-long-inserter"
data:extend({ long })