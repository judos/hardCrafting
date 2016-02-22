require "basic-lua-extensions"
require "defines"

-- Init --
script.on_init(function()
	init()
end)

script.on_load(function()
	init()
end)

function init()
	
end

script.on_event(defines.events.on_tick, function(event)
	if game.tick % 60 ~= 0 then return end
	
	if global.hardCrafting and game and not global.hardCrafting.updateTick then 
		global.hardCrafting.updateTick = game.tick
	end
	if global.hardCrafting and game.tick - global.hardCrafting.updateTick > 60*5 then
		if #global.hardCrafting.signalReceiver > 0 or #global.hardCrafting.signalRequester > 0 then
			PlayerPrint("hardCrafting: Please note that the signalReceiver has been removed from hardCrafting.")
			PlayerPrint("If you still want to use it you can download the separated mod neatLogistics at: ")
			PlayerPrint("https://github.com/judos/neatLogistics/releases")
		end
		global.hardCrafting = nil
	end
end)