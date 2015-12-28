data:extend({
	{
    type = "item",
    name = "rotor",
    icon = "__hardCrafting__/graphics/icons/rotor.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-product",
    order = "h2[electric-engine-unit]",
    stack_size = 50
  },
	{
		type="recipe",
		name="rotor",
		category = "crafting-with-fluid",
		ingredients={
			{"plastic-bar",2},{"iron-plate",1}
		},
		result="rotor",
		enabled = false
	}
})

addTechnologyUnlocksRecipe("flying", "rotor")