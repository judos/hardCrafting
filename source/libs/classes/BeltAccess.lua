require "libs.classes.TransportLinesAccess"

function newBeltAccess (beltEntity,accessFromPosition)
	local self = newTransportLinesAccess(
		beltEntity.get_transport_line(1),
		beltEntity.get_transport_line(2),
		beltEntity.position,
		accessFromPosition)
	self.beltEntity = beltEntity

	function self.isInput()
		local direction = self.beltEntity.direction
		local side = self.getSide()
		return side == (direction + 4)%8 -- must be 180°
	end

	return self
end


