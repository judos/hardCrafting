data:extend({
	{
    type = "item",
    name = "antenna",
    icon = "__hardCrafting__/graphics/icons/antenna.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-product",
    order = "h1[electric-engine-unit]",
    stack_size = 50
  },
	{
		type="recipe",
		name="antenna",
		category = "crafting",
		ingredients={
			{"copper-cable",5}
		},
		result="antenna",
		enabled = false
	}
})

addTechnologyUnlocksRecipe("robotics", "antenna")