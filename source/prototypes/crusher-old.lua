-- Entity
-- this is the old crusher which used to be a furnace (no selection of recipe)

data:extend({
  {
    type = "item",
    name = "crusher",
    icon = "__hardCrafting__/graphics/icons/crusher.png",
    flags = {"goes-to-quickbar"},
    subgroup = "advanced-processing-machine",
    order = "f",
    place_result = "crusher",
		enabled = false,
    stack_size = 50
  },
})


local crusher = deepcopy(data.raw["furnace"]["electric-furnace"])
crusher.name = "crusher"
crusher.icon =  "__hardCrafting__/graphics/icons/crusher.png"
crusher.crafting_categories = {"crusher"}
crusher.energy_usage = "80kW"
crusher.minable.result = "crusher-v2"
crusher.source_inventory_size = 1
crusher.result_inventory_size = 3
crusher.crafting_speed = 1
crusher.animation.filename="__hardCrafting__/graphics/entity/crusher/crusher-base.png"
crusher.working_visualisations[1] = {
	animation =
	{
		filename = "__hardCrafting__/graphics/entity/crusher/crusher-gears.png",
		priority = "high",
		width = 25,
		height = 15,
		frame_count = 4,
		animation_speed = 0.2,
		shift = {0.015625, 0.890625}
	},
	light = {intensity = 0.4, size = 6, shift = {0.0, 1.0}}
}
crusher.order="zzz"
data:extend({ crusher })