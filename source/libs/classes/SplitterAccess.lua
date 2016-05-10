require "libs.classes.TransportLinesAccess"

function newSplitterAccess (splitterEntity,accessTarget,accessFrom)
	local self = newTransportLinesAccess(
		nil, -- Will set line1, line2 later
		nil,
		accessTarget,
		accessFrom)
	self.splitterEntity = splitterEntity

	function self.isInput()
		local direction = self.splitterEntity.direction
		local side = self.getSide()
		return side == (direction + 4)%8 -- must be 180�
	end
	
	function isLeftConnected() -- access is going into left part seen from accessFrom perspective
		local direction = self.getSide()
		local pos = self.splitterEntity.position
		if direction == defines.direction.north then
			return pos.x > self.accessTarget.x
		elseif direction == defines.direction.east then
			return pos.y > self.accessTarget.y
		elseif direction == defines.direction.south then
			return pos.x < self.accessTarget.x
		elseif direction == defines.direction.west then
			return pos.y < self.accessTarget.y
		end
	end
	
	function getTransportLineIndexes()
		if isLeftConnected() then
			if self.isInput() then
				return {7,8}
			else -- if isOutput() then
				return {1,2}
			end
		else -- if isRightConnected() then
			if self.isInput() then
				return {5,6}
			else -- if isOutput() then
				return {3,4}
			end
		end
	end
	
	-- set correct transport lines
	local lineIndexes = getTransportLineIndexes()
	self.line1 = self.splitterEntity.get_transport_line(lineIndexes[1])
	self.line2 = self.splitterEntity.get_transport_line(lineIndexes[2])
	
	return self
end
