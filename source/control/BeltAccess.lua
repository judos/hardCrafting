function newBeltAccess (beltEntity,accessFromPosition)
	local self = {
		belt = beltEntity,
		line1 = beltEntity.get_transport_line(1),
		line2 = beltEntity.get_transport_line(2),
		accessFrom = accessFromPosition
	}
	
	local contains_item = function(itemName)
		if self.line1.get_item_count(itemName) > 0 then return true end
		if self.line2.get_item_count(itemName) > 0 then return true end
		return false
	end

	local function remove_item(itemStack)
		if self.line1.remove_item(itemStack) then return true end
		return self.line2.remove_item(itemStack)
	end

	local function can_insert_at_back()
		return self.line1.can_insert_at_back() or self.line2.can_insert_at_back()
	end

	local function insert_at_back(itemStack)
		local result = self.line1.insert_at_back(itemStack)
		if result then return true end
		return self.line2.insert_at_back(itemStack)
	end

	-- returns the direction on which side the belt is located relative to x,y, assuming they are neighbors
	local beltSide = function()
		local dx = self.belt.position.x-self.accessFrom.x
		local dy = self.belt.position.y-self.accessFrom.y
		if dx==-1 then
			return defines.direction.west
		elseif dx==1 then
			return defines.direction.east
		elseif dy==-1 then
			return defines.direction.north
		elseif dy==1 then
			return defines.direction.south
		end
	end

	local isInputBelt = function()
		local direction = self.belt.direction
		local side = beltSide()
		return side == (direction + 4)%8 -- must be 180°
	end

	return {
		remove_item = remove_item,
		can_insert_at_back = can_insert_at_back,
		insert_at_back = insert_at_back,
		beltSide = beltSide,
		isInputBelt = isInputBelt,
		contains_item = contains_item
	}
end


