function surfaceWithIndex(index)
	for name,surface in pairs(game.surfaces) do
		if surface.index == index then
			return surface
		end
	end
	warn("Surface with index "..tostring(index).." was not found")
	return nil
end
