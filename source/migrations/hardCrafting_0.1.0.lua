for i, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	
	-- technology unlocking migration:
	if force.technologies["logistics-2"].researched then
		force.recipes["fast-long-inserter"].enabled = true
	end
	
	if force.technologies["electric-engine"].researched then
		force.recipes["electro-magnet"].enabled = true
	end
	
	if force.technologies["flying"].researched then
		force.recipes["rotor"].enabled = true
	end
	
	if force.technologies["robotics"].researched then
		force.recipes["antenna"].enabled = true
	end
	
	if force.technologies["circuit-network"].researched then
		force.recipes["signal-receiver"].enabled = true
	end
end