local function check(force, technologyName, recipeName)
	force.recipes[recipeName].enabled = force.technologies[technologyName].researched
end

for i, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	
	check(force,"landfill","landfill2by2_withDirt")
	
	-- technology unlocking migration:
	--check(force, "logistics-2", "fast-long-inserter")
	
end