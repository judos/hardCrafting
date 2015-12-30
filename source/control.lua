require "defines"

-- Init --
script.on_init(function()
	init()
end)

script.on_load(function()
	init()
end)

function init()
	if global.hardCrafting == nil then 
		global.hardCrafting = {
			signalReceiver = {}
		}
	end
end

-- Setup and destroy --
script.on_event(defines.events.on_built_entity, function(event)
	createSignalReceiver(event.created_entity)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	createSignalReceiver(event.created_entity)
end)

function createSignalReceiver(entity)
	if entity.name == "signal-receiver" then
		table.insert(global.hardCrafting.signalReceiver, entity)
		entity.operable = false -- can't open gui
	end
end

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	-- invalidated during the tick event
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
	-- invalidated during the tick event
end)

-- Update tick --
script.on_event(defines.events.on_tick, function(event)
	-- update every 5 seconds
	if game.tick % 300 ~= 0 then return end
	
	for k,signalReceiver in pairs(global.hardCrafting.signalReceiver) do
		if signalReceiver.valid then
			local force = signalReceiver.force
			local logisticsSystem = force.find_logistic_network_by_position(signalReceiver.position,signalReceiver.surface)
			if logisticsSystem ~= nil then
				local stored = logisticsSystem.get_contents()
				local signal = {parameters = {}}
				local i = 1
				for k,v in pairs(stored) do
					signal.parameters[i]={signal={type = "item", name = k}, count = v, index = i}
					i = i + 1
				end
				signalReceiver.set_circuit_condition(defines.circuitconnector.red,signal)
			end
		else
			global.hardCrafting.signalReceiver[k] = nil
		end
	end
end)




