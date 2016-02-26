local furnacesExclude = table.set{"incinerator","electric-incinerator"}

for name,furnace in pairs(data.raw["furnace"]) do
	if not furnacesExclude[name] then
		print(name)
		furnace.result_inventory_size = math.max(furnace.result_inventory_size, 2)
	end
end
