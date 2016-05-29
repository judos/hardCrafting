-- parameters: resource entity
-- returns: table of SimpleItemStack with result which was mined (1 cycle of mining)
-- 					e.g. {{ name="iron-ore",1},{name="iron-nugget",1}}
function getMiningResultItems(resource)
	if not resource.valid then return {} end
	local products = resource.prototype.mineable_properties.products
	local resultStacks = {}
	for _,itemDescription in pairs(products) do
		if itemDescription.type == "item" then
			local prob = itemDescription.probability
			local isInfinite = resource.prototype.infinite_resource
			if isInfinite then
				--NOTE: The minimum_resource_amount is calculated wrongly and the normal_resource_amount isn't available at all
				--See interface request here: https://forums.factorio.com/viewtopic.php?f=28&t=24202&p=152421#p152421
				--local yield = resource.amount / (10* resource.prototype.minimum_resource_amount)
				local yield = 0.333
				if yield > 1 then yield = 1 end
				prob = prob * yield
			end
			local randomValue = math.random()
			if randomValue<prob then
				local amount = math.random(itemDescription.amount_min, itemDescription.amount_max)
				table.insert(resultStacks,{name=itemDescription.name, count = amount})
			elseif isInfinite then
				table.insert(resultStacks,{name="fake-generated-item", count = 1})
			end
		end
	end
	return resultStacks
end


function mineResource(resource)
	if not resource.valid then return {} end
	local itemStacksGenerated = getMiningResultItems(resource)
	local isInfinite = resource.prototype.infinite_resource
	if resource.amount > 1 then
		if (not isInfinite) or (resource.amount > resource.prototype.minimum_resource_amount) then
			resource.amount = resource.amount - 1
		end
	else
		resource.destroy()
	end
	return itemStacksGenerated
end


-- Used to change minable results from ore fields
function ressourceItemMinMaxProb(itemName, amountMin, amountMax, probability)
	return {
		type = "item",
		name = itemName,
		amount_min = amountMin,
		amount_max = amountMax,
		probability = probability
	}
end