require "constants"

if debug_master == nil then
	debug_master = true -- Master switch for debugging, prints debug stuff into the shell where factorio was started from
end
if debug_level == nil then
	debug_level = 2
end


function info(message)
	if debug_level<=1 then _debug(message,"INFO") end
end
function warn(message)
	if debug_level<=2 then _debug(message,"WARN") end
end
function err(message)
	if debug_level<=3 then _debug(message,"ERROR") end
end

function _debug(message,level)
	if not level then level="ANY" end
	if debug_master then
		if type(message) ~= "string" then
			message = serpent.block(message)
		end
		print("\n"..level.." "..fullModName..": "..message)
	end
end

function PlayerPrint(message)
	if not game then
		_debug(message)
		return
	end
	for _,player in pairs(game.players) do
		player.print(message)
	end
end
