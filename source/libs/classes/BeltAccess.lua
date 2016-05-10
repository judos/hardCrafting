require "libs.classes.TransportLinesAccess"

BeltAccess = {}
BeltAccess.__index = BeltAccess

setmetatable(BeltAccess, {
	__index = TransportLinesAccess,
	__call = function(class, ...)
		local self = setmetatable({},class)
		self:_init(...)
		return self
	end
})

function BeltAccess:_init(beltEntity, accessFromPosition)
	TransportLinesAccess._init(self,beltEntity.get_transport_line(1),
		beltEntity.get_transport_line(2),beltEntity.position,accessFromPosition)
	self.beltEntity = beltEntity
end

function BeltAccess:isInput()
	local direction = self.beltEntity.direction
	local side = self:getSide()
	return side == (direction + 4)%8 -- must be 180°
end

