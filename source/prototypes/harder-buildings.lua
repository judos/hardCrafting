-- Requirement: --


-- Item: --
addItem("iron-strut","intermediate-product","b[iron-gear-wheel]",50)

-- Recipes: --
--       item Name     category   subgroup     time    ingredients     			products		order
addRecipe("iron-strut","crafting",nil,0.5,{{"iron-plate",1}},{{"iron-strut",2}},nil)


for recipeName,t in pairs(data.raw["recipe"]) do
	local resultItem = t.result
	local item = data.raw["item"][resultItem]
	if item and item.place_result then
		local gear = recipeItemAmount(t,"iron-gear-wheel")
		local plates = recipeItemAmount(t,"iron-plate")
		print(tostring(gear)..", "..tostring(plates).." name: "..resultItem)
		if gear>0 and plates>0 then
			local subgroupName = item.subgroup
			local groupName = data.raw["item-subgroup"][subgroupName].group
			print(recipeName..", "..tostring(subgroupName)..", "..tostring(groupName).." "..serpent.block(t))
			if groupName == "production" then
				ChangeRecipe(recipeName,"iron-plate","iron-strut",plates*2)
			end
		end
	end
end
