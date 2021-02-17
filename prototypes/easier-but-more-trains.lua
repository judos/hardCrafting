require "libs.prototypes.recipe"

-- Change the cost of locomotives
local cost = settings.startup["hardcrafting-train-cost"].value
if cost ~= 1 then

	local locomotiveItems = {}
    for _,locomotive in pairs(data.raw.locomotive) do
		local item = locomotive
        if locomotive.minable then
            item = locomotive.minable.recipe
        end
        table.insert(locomotiveItems, item)
    end
	for _,data in pairs(data.raw.recipe) do
		local isLocomotive = false
		for _,name in pairs(locomotiveItems) do
			if recipeResultsContain(data,name) then
				isLocomotive = true
				break
			end
		end
		if isLocomotive then
			recipeChangeCostsByFactor(data.name,cost,true)
		end
	end

	-- Half the cost of cargo wagons
	if data.raw["recipe"]["cargo-wagon"] and data.raw["recipe"]["cargo-wagon"].ingredients then
		for _,materialCost in pairs(data.raw["recipe"]["cargo-wagon"].ingredients) do
			if materialCost["amount"] then
				materialCost["amount"] = math.ceil(materialCost["amount"] * cost)
			elseif materialCost[2] then
				materialCost[2] = math.ceil(materialCost[2] * cost)
			end
		end
	else
		err("Couldn't apply train modifications because missing recipe for cargo-wagon")
	end
end

local storage = settings.startup["hardcrafting-train-storage"].value
if storage ~= 1 then
	-- enforce Smaller inventory for trains
	for name,table in pairs(data.raw["cargo-wagon"]) do
		if table.inventory_size then
			table.inventory_size = math.ceil(table.inventory_size * storage)
			info(name.." inventory_size = "..table.inventory_size)
		end
		if table.weight then
			table.weight = math.ceil(table.weight *storage)
		end
	end
end

