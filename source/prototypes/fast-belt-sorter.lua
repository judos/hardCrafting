-- Item
local fastBeltSorter = deepcopy(data.raw.item["belt-sorter"])
overwriteContent(fastBeltSorter,{
  name = "fast-belt-sorter",
  place_result = "fast-belt-sorter"
})

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "fast-belt-sorter",
		enabled = false,
		ingredients = {
			{"belt-sorter", 1},
			{"advanced-circuit", 10},
      {"processing-unit", 10}
		},
		result = "fast-belt-sorter"
	}
})

-- Entity
local fastBeltSorter = deepcopy(data.raw.container["belt-sorter"])
fastBeltSorter.name = "fast-belt-sorter"
fastBeltSorter.minable.result = "fast-belt-sorter"

-- Technology
data:extend({
  {
    type = "technology",
    name = "advanced-belt-sorter",
    icon = "__hardCrafting__/graphics/technology/belt-sorter.png",
		icon_size = 128,
    prerequisites = {"belt-sorter" },
    effects = {},
    unit = {
      count = 50,
      ingredients = {
        {"science-pack-1", 3},
        {"science-pack-2", 3},
        {"science-pack-3", 1},
      },
      time = 15
    },
    order = "_belt-sorter2"
  }
})

addTechnologyUnlocksRecipe("fast-belt-sorter","fast-belt-sorter")
