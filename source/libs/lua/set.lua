set = set or {}
function set.table(s)
	local t = { }
  for v, _ in pairs(s) do 
		table.insert(t,v)
	end
  return t
end
