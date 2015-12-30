data:extend({
	{
    type = "item",
    name = "signal-receiver",
    icon = "__hardCrafting__/graphics/icons/signal-receiver.png",
    flags = {"goes-to-quickbar"},
    subgroup = "circuit-network",
		order = "b[combinators]-d[signal-receiver]",
    stack_size = 50,
		place_result = "signal-receiver"
  },
	{
		type="recipe",
		name="signal-receiver",
		category = "crafting",
		ingredients={
			{"antenna",1},{"steel-plate",2},{"electronic-circuit",5},{"copper-cable",4}
		},
		result="signal-receiver",
		enabled = false
	}
})

addTechnologyUnlocksRecipe("circuit-network", "signal-receiver")

receiver = deepcopy(data.raw["constant-combinator"]["constant-combinator"])
receiver.name = "signal-receiver"
receiver.minable.result = "signal-receiver"
receiver.item_slot_count = 10000 -- depends on number of signals available
receiver.operable = false
receiver.sprite.filename = "__hardCrafting__/graphics/entity/signal-receiver/signal-receiver.png",
data:extend({ receiver })