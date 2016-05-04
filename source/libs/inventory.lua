-- Adds one content table to another one
-- Does not modify a table in place
function addContentsTables(content1,content2)
	local result = deepcopy(content1)
	for name,amount in pairs(content2) do
		if result[name] ~= nil then
			result[name] = result[name] + amount
		else
			result[name] = amount
		end
	end
	return result
end

-- Moves all items from first inventory to second one
-- Returns: false if not all items could be moved
function moveInventoryToInventory(invSource,invTarget)
	for itemName,count in pairs(invSource.get_contents()) do
		local stack = {name=itemName,count=count}
		if invTarget.can_insert(stack) then
			stack.count = invTarget.insert(stack)
			stack.count = invSource.remove(stack)
		else
			return false -- couldn't move all, target chest is full
		end
		if stack.count ~= count then return false end
	end
	return true
end

-- Deprecated, use new method below with correct name
function killItemsInInventor(inventory, itemName)
	inventory.remove({name=itemName,count=1000000})
end
-- Removes all items of one type from an inventory
function killItemsInInventory(inventory, itemName)
	inventory.remove({name=itemName,count=1000000})
end

-- Spills whole inventory on the surface
function spillInventory(inventory, surface, position)
	for i=1,#inventory do
		local stack = inventory[i]
		if stack and stack.valid and stack.valid_for_read then
			surface.spill_item_stack(position,stack)
		end
	end
end