function table.set(t) -- set of list
  local u = { }
  for _, v in ipairs(t) do u[v] = true end
  return u
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- DyTech source codes:
--[[Debug Functions]]--
debug_master = true -- Master switch for debugging, shows most things!

function debugp(message)
	if debug_master then
		print(message)
	end
end

function debug(message)
	if debug_master then
		PlayerPrint(message)
	end
end

function PlayerPrint(message)
	if type(message) ~= "string" then
		message = serpent.block(message)
	end
	for _,player in pairs(game.players) do
		player.print(message)
	end
end