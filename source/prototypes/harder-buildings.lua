-- Requirement: --
require "find-raw-ingredients"
require "prototypes.pulverizer"
require "prototypes.harder-iron-processing"
require "prototypes.harder-copper-processing"

local recipeWhiteList = table.set({
	"gun-turret", "laser-turret", "radar", "rocket-silo", "basic-splitter", "fast-splitter", "express-splitter", "smart-inserter",  
	"big-electric-pole", "substation", "train-stop", "diesel-locomotive", "tank", "logistic-robot", 
	"construction-robot", "logistic-chest-active-provider", "logistic-chest-passive-provider", 
	"logistic-chest-requester", "logistic-chest-storage", "roboport", 
	"solar-panel", "basic-accumulator", "pumpjack", "electric-furnace", "electric-incinerator", "pulverizer", "assembling-machine-2", 
	"assembling-machine-3", "oil-refinery", "chemical-plant", "lab", "basic-beacon" })

-- Item: --
addItem("scrap-metal","raw-resource","z[scrap-metal]",50)

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     			products		order
addRecipe("scrap-metal-processing","pulverizer","raw-resource",8,{{"scrap-metal",5}},{{"pulverized-iron",3},{"copper-dust",2}},"z[scrap-metal]")

for recipeName,recipe in pairs(data.raw["recipe"]) do
	local resultItem = recipe.result
	local item = data.raw["item"][resultItem]
	if item and item.place_result and recipeWhiteList[recipeName] then
		local iron = findRawIngredient(resultItem,"iron-plate")
		local copper = findRawIngredient(resultItem,"copper-plate")
		--warn(resultItem..": uses "..iron.." iron + "..copper.." copper")

		if iron >= 10 and copper>= 5 then
			--info(resultItem.." -> scrap")
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
