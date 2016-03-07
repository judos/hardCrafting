-- Requirement: --
require "find-raw-ingredients"

-- Item: --
--addItem("iron-strut","intermediate-product","b[iron-gear-wheel]",50)
addItem("scrap-metal","raw-resource","b[iron-gear-wheel]",50)

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     			products		order
--addRecipe("iron-strut","crafting",nil,0.5,{{"iron-plate",1}},{{"iron-strut",2}},nil)


for recipeName,recipe in pairs(data.raw["recipe"]) do
	local resultItem = recipe.result
	local item = data.raw["item"][resultItem]
	if item and item.place_result then
		local iron = findRawIngredient(resultItem,"iron-plate")
		local copper = findRawIngredient(resultItem,"copper-plate")
		
		--warn(resultItem..": uses "..iron.." iron + "..copper.." copper")
		
		if iron >= 10 and copper>= 5 then
			info(resultItem.." -> scrap")
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
