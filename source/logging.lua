
debug_master = true -- Master switch for debugging, shows most things!
debug_level = 1 -- 1=info 2=warning 3=error

function info(message)
	if debug_level<=1 then debug(message,"INFO") end
end
function warn(message)
	if debug_level<=2 then debug(message,"WARN") end
end
function error(message)
	if debug_level<=3 then debug(message,"ERROR") end
end

function debug(message,level)
	if not level then level="ANY" end
	if debug_master then
		if type(message) ~= "string" then
			message = serpent.block(message)
		end
		print(level..": "..message)
	end
end

local printIndex = 1
function PlayerPrint(message)
	if not game then
		debug(message)
		return
	end
	for _,player in pairs(game.players) do
		player.print(printIndex.." "..message)
		printIndex = printIndex + 1
	end
end
