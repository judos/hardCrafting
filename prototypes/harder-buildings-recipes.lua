if settings.startup["hardcrafting-complex-crafting-byproduct"].value == true then
	-- Requirement: --

	local recipeWhiteList = table.set({
		"splitter", "fast-splitter", "express-splitter", "filter-inserter","stack-inserter","stack-filter-inserter",
		"logistic-robot", "construction-robot", "roboport",
		"logistic-chest-active-provider", "logistic-chest-passive-provider", "logistic-chest-requester", "logistic-chest-storage", "logistic-chest-buffer",
		"big-electric-pole", "substation", "train-stop", "locomotive", "tank",
		"solar-panel", "accumulator",
		"pumpjack", "electric-furnace", "electric-incinerator", "pulverizer", "assembling-machine-2",
		"assembling-machine-3", "oil-refinery", "chemical-plant", "lab", "beacon", "centrifuge",
		"nuclear-reactor", "heat-exchanger", "heat-pipe",
		"gun-turret", "laser-turret", "radar", "rocket-silo"
	})

	-- Recipes: --
	--           n                ame     category   subgroup     time    ingredients     			products		order
	addRecipe("scrap-metal-processing","hc-pulverizer","by-products",8,{{"scrap-metal",5}},{{"pulverized-iron",3},{"copper-dust",2}},"z[scrap-metal]")

	for recipeName,recipe in pairs(data.raw["recipe"]) do
		local resultItem = recipe.result
		local item = data.raw["item"][resultItem]
		if item and item.place_result and recipeWhiteList[recipeName] then
			local results = recipe.results
			if not results then
				local resultAmount = recipe.result_count or 1
				results = { {type="item", name=recipe.result, amount=resultAmount} }
			end
			table.insert(results, { type="item", name="scrap-metal",amount=1})
			recipe.results = results
			recipe.result = nil
			recipe.result_count = nil
			if not recipe.icon then
				recipe.icon = data.raw["item"][resultItem].icon
    			recipe.icon_size = data.raw["item"][resultItem].icon_size
    			recipe.icon_mipmaps = data.raw["item"][resultItem].icon_mipmaps
			end
			if not recipe.subgroup then
				recipe.subgroup = data.raw["item"][resultItem].subgroup
			end
			if not recipe.order then
				recipe.order = data.raw["item"][resultItem].order
			end
		end
	end
end