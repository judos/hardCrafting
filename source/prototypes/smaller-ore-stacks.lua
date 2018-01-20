if settings.startup["hardcrafting-smaller-ore-stacks"].value == true then

	local ores = {}
	for _,resource in pairs(data.raw["resource"]) do
		if resource.minable.result ~= nil then
			ores[resource.minable.result] = true
		else
			for _,ore in pairs(resource.minable.results) do
				ores[ore.name] = true
			end
		end
	end
	
	for oreName,_ in pairs(ores) do
		if data.raw.item[oreName] ~= nil then
			data.raw.item[oreName].stack_size = data.raw.item[oreName].stack_size / 2
		end
	end
end