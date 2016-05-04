function table.addTable(t,toAdd)
	for k,v in pairs(toAdd) do t[k] = v end
end

function table.set(t) -- set of list
  local u = { }
  for _, v in ipairs(t) do u[v] = true end
  return u
end

function string.starts(str,prefix)
  return string.sub(str,1,string.len(prefix))==prefix
end

function string.ends(str,suffix)
   return suffix=='' or string.sub(str,-string.len(suffix))==suffix
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function split(s, delimiter)
  if not s then return {} end
  result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
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
