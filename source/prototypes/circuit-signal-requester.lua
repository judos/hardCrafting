data:extend({
	{
    type = "item",
    name = "circuit-signal-requester",
    icon = "__hardCrafting__/graphics/icons/signal-receiver.png",
    flags = {"goes-to-quickbar"},
    subgroup = "circuit-network",
		order = "b[combinators]-d[signal-receiver]",
    stack_size = 50,
		place_result = "circuit-signal-requester"
  },
	{
		type="recipe",
		name="circuit-signal-requester",
		category = "crafting",
		ingredients={
			{"antenna",1},{"steel-plate",2},{"electronic-circuit",5},{"copper-cable",4}
		},
		result="circuit-signal-requester",
		enabled = false
	}
})

addTechnologyUnlocksRecipe("circuit-network", "circuit-signal-requester")

requester = deepcopy(data.raw["constant-combinator"]["constant-combinator"])
requester.name = "circuit-signal-requester"
requester.minable.result = "circuit-signal-requester"
requester.item_slot_count = 10000 -- depends on number of signals available
requester.operable = false
requester.sprite.filename = "__hardCrafting__/graphics/entity/signal-receiver/signal-receiver.png",
data:extend({ requester })