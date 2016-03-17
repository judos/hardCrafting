
-- Item
local beltSorter = deepcopy(data.raw["item"]["wooden-chest"])
beltSorter["name"]="belt-sorter"
beltSorter["order"]="z[belt-sorter]"
beltSorter["subgroup"]="inserter"
beltSorter["place_result"]="belt-sorter"
beltSorter.icon = "__hardCrafting__/graphics/icons/belt-sorter.png"
data:extend({	beltSorter })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "belt-sorter",
		enabled = false,
		ingredients = {
			{"smart-chest", 1},
			{"steel-plate", 10},
			{"advanced-circuit", 10}
		},
		result = "belt-sorter"
	}
})

-- Entity
local beltSorter = deepcopy(data.raw["container"]["wooden-chest"])
beltSorter.name = "belt-sorter"
beltSorter.minable.result = "belt-sorter"
beltSorter.inventory_size = 40
beltSorter.icon = "__hardCrafting__/graphics/icons/belt-sorter.png"
beltSorter.picture.filename="__hardCrafting__/graphics/entity/belt-sorter.png"
beltSorter.fuel_value = nil
data:extend({	beltSorter })

-- Technology
data:extend({
  {
    type = "technology",
    name = "belt-sorter",
    icon = "__hardCrafting__/graphics/technology/belt-sorter.png",
		icon_size = 128,
    prerequisites = {"circuit-network","advanced-electronics" },
    effects = {},
    unit = {
      count = 50,
      ingredients = {
        {"science-pack-1", 3},
      },
      time = 15
    },
    order = "_belt-sorter"
  }
})

addTechnologyUnlocksRecipe("belt-sorter","belt-sorter")
