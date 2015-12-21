local function itemMinMaxProb(itemName, amountMin, amountMax, probability)
	return {
		type="item",
		name = itemName,
		amount_min = amountMin,
		amount_max = amountMax,
		probability = probability
	}
end
data.raw["resource"]["iron-ore"].minable.result = nil
data.raw["resource"]["iron-ore"].minable.results = {
	itemMinMaxProb("iron-ore",   1, 5, 0.3), -- 1 item at percentage 0.9 --
	itemMinMaxProb("iron-nugget",1, 1, 0.1),
	itemMinMaxProb("gravel",     1, 4, 0.3),
	itemMinMaxProb("dirt",       1, 1, 1)
}