-- Straight rails cost a bit less steel but much more stone
data.raw["recipe"]["straight-rail"].result_count = 3
data.raw["recipe"]["straight-rail"].ingredients = {
	{"stone", 3},
  {"iron-stick", 1},
  {"steel-plate", 1}
}

data.raw["recipe"]["curved-rail"].result_count = 3
data.raw["recipe"]["curved-rail"].ingredients = {
	{"stone", 6},
	{"iron-stick", 4},
	{"steel-plate", 4}
}

-- Half the cost of diesel-locomotive
for _,materialCost in pairs(data.raw["recipe"]["diesel-locomotive"].ingredients) do
	materialCost[2] = math.ceil(materialCost[2]/2)
end

-- Half the cost of cargo wagons
for _,materialCost in pairs(data.raw["recipe"]["cargo-wagon"].ingredients) do
	materialCost[2] = math.ceil(materialCost[2]/2)
end

data.raw["cargo-wagon"]["cargo-wagon"].inventory_size = 15
data.raw["cargo-wagon"]["cargo-wagon"].weight = 500