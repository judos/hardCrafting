
function table.addTable(t,toAdd)
	if toAdd then
		for k,v in pairs(toAdd) do t[k] = v end
	end
end

function table.set(t) -- set of list
  local s = { }
  for _, v in ipairs(t) do s[v] = true end
  return s
end

function table.clear(t)
	local count = #t
	for i=0, count do t[i]=nil end
end

function table.contains(table,value)
	if table == nil then return false end
	for k,v in pairs(table) do
		if v == value then return true end	
	end
	return false
end