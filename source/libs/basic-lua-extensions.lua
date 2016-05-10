function table.addTable(t,toAdd)
	if toAdd then
		for k,v in pairs(toAdd) do t[k] = v end
	end
end

function table.set(t) -- set of list
  local u = { }
  for _, v in ipairs(t) do u[v] = true end
  return u
end

function table.clear(t)
	local count = #t
	for i=0, count do t[i]=nil end
end

function table.contains(table,value)
	for k,v in pairs(table) do
		if v == value then return true end	
	end
	return false
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

-- See: http://lua-users.org/wiki/MakingLuaLikePhp
function split(str,divider) -- credit: http://richard.warburton.it
  if divider=='' then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return str:find(divider,pos,true) end do
    table.insert(arr,str:sub(pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,str:sub(pos)) -- Attach chars right of last divider
  return arr
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
