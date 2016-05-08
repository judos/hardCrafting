
-- each known gui defines these functions:
gui = {} -- [$entityName] = { open = $function(player,entity), close = $function(player) }

function initGui()
	if global.gui == nil then global.gui = {playerData = {}} end
end

function tickGui()
	if game.tick % 10 ~= 0 then return end
	for _,player in pairs(game.players) do
		if player.connected then
			local openEntity = player.opened
			local playerName = player.name
			if global.gui.playerData[playerName] == nil then global.gui.playerData[playerName] = {} end
			local playerData = global.gui.playerData[playerName]
			local openGui = playerData.openGui
			if openEntity == nil then
				if openGui ~= nil then
					if gui[openGui] ~= nil and gui[openGui].close ~= nil then
						gui[openGui].close(player)
					end
					playerData.openGui = nil
				end
			elseif openGui == nil then
				openGui = openEntity.name
				playerData.openGui = openGui
				if gui[openGui] ~= nil and gui[openGui].open ~= nil then
					gui[openGui].open(player,openEntity)
				end
			end
		end
	end
end