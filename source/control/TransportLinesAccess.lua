function newTransportLinesAccess (line1,line2,accessTarget,accessFrom)
	local self = {
		line1 = line1,
		line2 = line2	
	}
	
	function self.contains_item(itemName)
		if self.line1.get_item_count(itemName) > 0 then return true end
		if self.line2.get_item_count(itemName) > 0 then return true end
		return false
	end

	function self.remove_item(itemStack)
		if self.line1.remove_item(itemStack) then return true end
		return self.line2.remove_item(itemStack)
	end

	function self.can_insert_at_back()
		return self.line1.can_insert_at_back() or self.line2.can_insert_at_back()
	end

	function self.insert_at_back(itemStack)
		if self.line1.insert_at_back(itemStack) then return true end
		return self.line2.insert_at_back(itemStack)
	end

	-- returns the direction on which side the belt is located relative to x,y, assuming they are neighbors
	function self.getSide()
		warn("target is: "..serpent.block(accessTarget))
		warn("source is: "..serpent.block(accessFrom))
		local dx = accessTarget.x - accessFrom.x
		local dy = accessTarget.y - accessFrom.y
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

	return self
end


