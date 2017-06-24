if settings.startup["hardcrafting-train-modifications"].value == true then
  -- Half the cost of diesel-locomotive
  for _,materialCost in pairs(data.raw["recipe"]["locomotive"].ingredients) do
	if materialCost["amount"] then
		materialCost["amount"] = math.ceil(materialCost["amount"] / 2)
	elseif materialCost[2] then
		materialCost[2] = math.ceil(materialCost[2] / 2)
	end
  end

  -- Half the cost of cargo wagons
  for _,materialCost in pairs(data.raw["recipe"]["cargo-wagon"].ingredients) do
	if materialCost["amount"] then
		materialCost["amount"] = math.ceil(materialCost["amount"] / 2)
	elseif materialCost[2] then
		materialCost[2] = math.ceil(materialCost[2] / 2)
	end
  end

  -- enforce Smaller inventory for trains
  for name,table in pairs(data.raw["cargo-wagon"]) do
	if table.inventory_size then
		table.inventory_size = math.ceil(table.inventory_size / 2)
		info(name.." inventory_size = "..table.inventory_size)
	end
	if table.weight then
		table.weight = math.ceil(table.weight / 2)
	end
  end
end
