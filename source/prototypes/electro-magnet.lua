data:extend({
	{
    type = "item",
    name = "electro-magnet",
    icon = "__hardCrafting__/graphics/icons/electro-magnet.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-product",
    order = "h3[electric-engine-unit]",
    stack_size = 50
  },
	{
		type="recipe",
		name="electro-magnet",
		category = "crafting",
		ingredients={
			{"copper-cable",4},{"iron-plate",1}
		},
		result="electro-magnet",
		enabled = false
	}
})

addTechnologyUnlocksRecipe("electric-engine", "electro-magnet")