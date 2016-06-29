-- Half the cost of diesel-locomotive
for _,materialCost in pairs(data.raw["recipe"]["diesel-locomotive"].ingredients) do
	materialCost[2] = math.ceil(materialCost[2]/2)
end

-- Half the cost of cargo wagons
for _,materialCost in pairs(data.raw["recipe"]["cargo-wagon"].ingredients) do
	materialCost[2] = math.ceil(materialCost[2]/2)
end

-- enforce Smaller inventory for trains
for name,table in pairs(data.raw["cargo-wagon"]) do
	table.inventory_size = math.ceil(table.inventory_size / 2)
	info(name.." inventory_size = "..table.inventory_size)
	table.weight = math.ceil(table.weight / 2)
end

