require "control.BeltAccess"
require "control.SplitterAccess"

BeltFactory={}
BeltFactory.supportedTypes = {"transport-belt","splitter","transport-belt-to-ground"}

BeltFactory.accessFor = function(entity,accessTarget,accessFrom)
	if entity.type == "transport-belt" then
		return newBeltAccess(entity,accessFrom)
	elseif entity.type == "splitter" then
		return newSplitterAccess(entity,accessTarget,accessFrom)
	elseif entity.type == "transport-belt-to-ground" then
		return newBeltAccess(entity,accessFrom)
	else
		warn("Invalid entity type: "..entity.type.." to create an access object.")
	end
end