
-- Used to change minable results from ore fields
function ressourceItemMinMaxProb(itemName, amountMin, amountMax, probability)
	return {
		type = "item",
		icon_size = 32,
		name = itemName,
		amount_min = amountMin,
		amount_max = amountMax,
		probability = probability
	}
end