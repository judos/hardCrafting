data:extend(
{
	{
		type = "bool-setting",
		name = "hardcrafting-rich-ores",
		setting_type = "startup",
		default_value = true,
		order = "a"
	},
	{
		type = "bool-setting",
		name = "hardcrafting-complex-crafting-byproduct",
		setting_type = "startup",
		default_value = true,
		order = "b"
	},
	{
		type = "bool-setting",
		name = "hardcrafting-extra-inserters",
		setting_type = "startup",
		default_value = true,
		order = "c"
	},
	{
		type = "double-setting",
		name = "hardcrafting-train-cost",
		setting_type = "startup",
		order = "d",
		default_value = 0.5,
    minimum_value = 0.1,
    maximum_value = 5,
	},
	{
		type = "double-setting",
		name = "hardcrafting-train-storage",
		setting_type = "startup",
		order = "d",
		default_value = 0.5,
    minimum_value = 0.1,
    maximum_value = 5,
	},
	{
		type = "double-setting",
		name = "hardcrafting-smaller-ore-stacks",
		setting_type = "startup",
		default_value = true,
		order = "d",
		default_value = 0.5,
    minimum_value = 0.1,
    maximum_value = 5,
	},
	{
		type = "bool-setting",
		name = "hardcrafting-hard-oil",
		setting_type = "startup",
		default_value = true,
		order = "d"
	},
})