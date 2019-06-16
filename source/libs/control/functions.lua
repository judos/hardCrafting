
require "libs.control.entities" --lets your classes register event functions in general
require "libs.control.gui" --lets your classes register guis

bit = require "libs.bit.numberlua"
 
 
 
prototypesForGroup = function(type)
	if type == "item" then
		return game.item_prototypes
	elseif type == "fluid" then
		return game.fluid_prototypes
	elseif type == "signal" then
		return game.virtual_signal_prototypes
	end
end