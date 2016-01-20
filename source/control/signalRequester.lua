local requester_search = {{1,0},{0,1},{-1,0},{0,-1}}

function updateSignalRequester(event)
	-- update every 10 ticks
	if game.tick % 10 ~= 0 then return end
	
	for k,signalRequester in pairs(global.hardCrafting.signalRequester) do
		if signalRequester.valid then
			local surface = signalRequester.surface
			local x = signalRequester.position.x
			local y = signalRequester.position.y
			local assemblers = {}
			for _,coordinatePair in ipairs(requester_search) do
				local position = {x + coordinatePair[1], y + coordinatePair[2]}
				local entities = surface.find_entities_filtered{area = {position,position},type="assembling-machine"}
				if entities ~= nil then
					for _,entity in ipairs(entities) do
						table.insert(assemblers,entity)
					end
				end
			end
			
			local filterForChest = {}
			--check all assemblers and add up ingredients to use as filter in the chest
			for _,assembler in ipairs(assemblers) do
				if assembler.recipe ~= nil then
					local output = assembler.get_inventory(defines.inventory.assembling_machine_output)
					local outputItems = output.get_item_count()
					local recipeOutputAmount = assembler.recipe.products[1].amount
					-- when crafting, let the inserters time to fill assembler before requesting more items
					if assembler.is_crafting() then outputItems = outputItems + recipeOutputAmount end
					
					if outputItems < 2*recipeOutputAmount then
						local available = assembler.get_inventory(defines.inventory.assembling_machine_input).get_contents()
						
						local items = assembler.recipe.ingredients
						for _,itemDescription in ipairs(items) do
							if itemDescription["type"]=="item" then
								local itemName = itemDescription["name"]
								if not filterForChest[itemName] then
									filterForChest[itemName] = 0
								end
								local required = 2 - outputItems
								if available[itemName]==nil then
									filterForChest[itemName] = filterForChest[itemName] + itemDescription["amount"]*required
								else
									filterForChest[itemName] = filterForChest[itemName] + math.max(itemDescription["amount"]*required-available[itemName],0)
								end
							end
						end
					end
				end
			end

			local signal = {parameters = {}}
			local i = 1
			for k,v in pairs(filterForChest) do
				signal.parameters[i]={signal={type = "item", name = k}, count = v, index = i}
				i = i + 1
			end
			signalRequester.set_circuit_condition(defines.circuitconnector.red,signal)
		else
			global.hardCrafting.signalRequester[k] = nil
		end
	end
end