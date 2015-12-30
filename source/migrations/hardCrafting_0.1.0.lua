local function check(force, technologyName, recipeName)
	if force.technologies[technologyName].researched then
		force.recipes[recipeName].enabled = true
	end
end

for i, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	
	-- technology unlocking migration:
	check(force, "logistics-2", "fast-long-inserter")
	check(force, "electric-engine", "electro-magnet")
	check(force, "flying", "rotor")
	check(force, "robotics", "antenna")
	check(force, "circuit-network", "signal-receiver")
	
	check(force, "incinerator", "incinerator")
	check(force, "electric-incinerator", "electric-incinerator")
	
	check(force, "crusher", "crusher")
	check(force, "pulverizer", "pulverizer")
end