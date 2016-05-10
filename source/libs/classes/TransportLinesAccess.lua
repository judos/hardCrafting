require "libs.inventory"


TransportLinesAccess = {}
TransportLinesAccess.__index = TransportLinesAccess

setmetatable(TransportLinesAccess, {
	__call = function(class, ...)
		local self = setmetatable({},class)
		self:_init(...)
		return self
	end
})

function TransportLinesAccess:_init(line1,line2,accessTarget,accessFrom)
	self.line1 = line1
	self.line2 = line2
	self.accessTarget = accessTarget
	self.accessFrom = accessFrom
end

function TransportLinesAccess:isValid()
	return self.line1.valid and self.line2.valid 
end

function TransportLinesAccess:get_contents()
	return addContentsTables(self.line1.get_contents(),self.line2.get_contents())
end

function TransportLinesAccess:contains_item(itemName)
	if self.line1.get_item_count(itemName) > 0 then return true end
	if self.line2.get_item_count(itemName) > 0 then return true end
	return false
end

function TransportLinesAccess:remove_item(itemStack)
	local result = self.line1.remove_item(itemStack)
	if result>0 then return result end
	return self.line2.remove_item(itemStack)
end

function TransportLinesAccess:can_insert_at_back()
	return self.line1.can_insert_at_back() or self.line2.can_insert_at_back()
end

function TransportLinesAccess:insert_at_back(itemStack)
	if self.line1.insert_at_back(itemStack) then return true end
	return self.line2.insert_at_back(itemStack)
end

-- returns the direction on which side the belt is located relative to x,y, assuming they are neighbors
function TransportLinesAccess:getSide()
	local dx = self.accessTarget.x - self.accessFrom.x
	local dy = self.accessTarget.y - self.accessFrom.y
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





