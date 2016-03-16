-- Incinerator hidden Recipes
-- This file must be included only in data-final-fixes, otherwise not all items can be inserted in the incinerator

local burnTime = {
	landfill2by2 = 75,
	landfill4by4 = 250
}

local types = {"item", "gun", "armor", "ammo", "blueprint", "deconstruction-item","mining-tool"}
for _,typ in pairs(types) do
	for name,itemTable in pairs(data.raw[typ]) do
		
		local time = 4
		if burnTime[name] then time = burnTime[name] end
		
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
