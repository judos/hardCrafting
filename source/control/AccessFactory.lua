require "control.BeltAccess"
require "control.SplitterAccess"

BeltFactory={}
BeltFactory.accessFor = function(entity,accessTarget,accessFrom)
	if entity.type == "transport-belt" then
		return newBeltAccess(entity,accessFrom)
	elseif entity.type == "splitter" then
		return newSplitterAccess(entity,accessTarget,accessFrom)
	else
		warn("Invalid entity type: "..entity.type.." to create an access object.")
	end
end