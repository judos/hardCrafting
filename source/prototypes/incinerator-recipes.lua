-- Incinerator hidden Recipes
-- This file must be included only in data-final-fixes, otherwise not all items can be inserted in the incinerator

local burnTime = {
	landfill2by2 = 75,
	landfill4by4 = 250
}

local types = {
	"item", "rail-planner", "module", 
	"tool", -- research packs
	"item-with-entity-data", -- cars, trains, wagon, tanks
	"blueprint", "deconstruction-item", "blueprint-book",
	"gun", "armor", "ammo", "mining-tool", "repair-tool", "selection-tool",
	"capsule" -- capsules, grenades, discharge defence
}

for _,typ in pairs(types) do
	for name,itemTable in pairs(data.raw[typ]) do

		local time = 4
		if burnTime[name] then time = burnTime[name] end

		--Get the fuel value of the item.
		local fuelValue
		if itemTable.fuel_value then
			fuelValue = tonumber(itemTable.fuel_value:sub(1,itemTable.fuel_value:len()-2))
		else
			fuelValue = 0
		end

		--If the item is a raw material and has a fuel value, dont create an incinerator recipe for it.
		if itemTable.subgroup ~= "raw-material" or fuelValue == 0 then
			data:extend({
				{
					type = "recipe",
					name = "incinerate_"..name,
					category = "incinerator",
					icon = "__hardCrafting__/graphics/icons/fire.png",
					hidden = true,
					ingredients = {{name, 1}},
					energy_required = time,
					results =
					{
						{type="item", name="coal-dust", probability=0.1, amount_min=1, amount_max=1},
					}
				}
			})
		end

	end
end
