require "libs.logging"
require "libs.basic-lua-extensions"
require "libs.find-raw-ingredients"
require "libs.inventory"
require "libs.prototypes"
require "libs.resources"
require "libs.recipe"
require "libs.technology"


function overwriteContent(originalTable,newContent)
	if originalTable == nil then
		err("could not overwrite content of nil with new content: "..serpent.block(newContent))
		return
	end
	for k,d in pairs(newContent) do
		originalTable[k]=d
	end
end


function removeAfterSign(str, separator)
	local pos = str:find(separator)
	if pos == nil then return str end
	return str:sub(1,pos-1)
end

