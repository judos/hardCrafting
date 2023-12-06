

for name,table in pairs(data.raw["mining-drill"]) do
	table.storage_slots = math.max(4,table.storage_slots or 1)
end

data
    .raw
    ["mining-drill"]
    ["burner-mining-drill"]
    .energy_source
    .fuel_inventory_size
    = settings.startup["burner-miner-fuel-slots"].value



