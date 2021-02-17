require "libs.logging"

function string.starts(str,prefix)
  return string.sub(str,1,string.len(prefix))==prefix
end

function string.ends(str,suffix)
   return suffix=='' or string.sub(str,-string.len(suffix))==suffix
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

-- e.g. formatWith("%time - %msg",{time = "10pm", msg = "Hello"} -> "10pm - Hello"
function formatWith(formatStr,parameters)
	if not parameters then
		err("ERROR: missing parameters for formatWith in libs.lua.string")
		parameters = {}
	end
	repeat
		local before = formatStr
		local tag = formatStr:match("%%(%a+)")
		if tag then
			if not parameters[tag] then parameters[tag]=tag end
			formatStr = formatStr:gsub("%%"..tag, parameters[tag])
		end
	until tag == nil or before == formatStr
	return formatStr
end