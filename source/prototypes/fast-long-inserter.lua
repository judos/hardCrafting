data:extend(
{
  {
    type = "item",
    name = "fast-long-inserter",
    icon = "__hardCrafting__/graphics/icons/fast-long-inserter.png",
    flags = {"goes-to-quickbar"},
    subgroup = "inserter",
    order = "c2[fast-long-inserter]",
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
      {"basic-inserter", 1}
    },
    result = "fast-long-inserter"
  }
})

addTechnologyUnlocksRecipe("logistics-2","fast-long-inserter")

local long = deepcopy(data.raw["inserter"]["long-handed-inserter"])
long.name = "fast-long-inserter"
long.icon = "__hardCrafting__/graphics/icons/fast-long-inserter.png"
long.minable.result = "fast-long-inserter"
long.extension_speed = 0.1
long.rotation_speed = 0.04
long.hand_base_picture.filename = "__hardCrafting__/graphics/entity/fast-long-inserter/hand-base.png"
long.hand_closed_picture.filename = "__hardCrafting__/graphics/entity/fast-long-inserter/hand-closed.png"
long.hand_open_picture.filename = "__hardCrafting__/graphics/entity/fast-long-inserter/hand-open.png"
long.platform_picture.sheet.filename = "__hardCrafting__/graphics/entity/fast-long-inserter/platform.png"
data:extend({ long })