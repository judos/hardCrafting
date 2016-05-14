local resourceRecipes = {
	"crushed-iron",
	"crushed-iron-big",
	"pulverized-iron",
	"pulverized-iron-big",
	
	"copper-dust",
	"copper-dust-big",
	"copper-sulfat",
	"copper-plate|sulfat",
	
	"steel-dust",
	"steel-dust|2",
	"coal-dust",
	"gravel-pile",
	"gravel"
}

for _, module in pairs(data.raw.module) do
	if module.limitation and module.effect and module.effect.productivity then
		if module.effect.productivity.bonus <= 0.101 then
			for _, resources in pairs(resourceRecipes) do
				table.insert(module.limitation, resources)
			end
		end
	end
end
