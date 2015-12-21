for i, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	
	-- technology unlocking migration:
	if force.technologies["logistics-2"].researched then
		force.recipes["fast-long-inserter"].enabled = true
	end
end