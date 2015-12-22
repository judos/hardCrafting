local furnaces = {"stone-furnace","steel-furnace","electric-furnace"}

for _,name in pairs(furnaces) do
	local f = data.raw["furnace"][name]
	f.result_inventory_size = math.max(f.result_inventory_size, 2)
end