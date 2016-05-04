function printMissingRecipeLocalization()
	if not global.hardCrafting.localizationNotice then
		local newLocale = {}
		local newStrings = false
		for name,table in pairs(game.players[1].force.recipes) do
			warn("checking recipe: "..name)
			if recipeResultsItemAmount(table,"scrap-metal") > 0 then
				print("recipe "..name.." might not have localization")
				local itemName = table.products[1]["name"]
				local item = game.item_prototypes[itemName]
				newLocale[name]= item.localised_name
				newStrings = true
				if not newLocale[name] then
					local entityName = item.place_result.localised_name
					newLocale[name]=entityName
				end
			end
		end
		if newStrings then
			print("writing to file...")
			local out = ""
			for recipeName,itemName in pairs(newLocale) do
				out=out..recipeName..","..itemName[1].."\n"
			end
			game.write_file("hardCrafting-test.txt",out)
			
			out = "local recipeWhiteList = table.set({"
			for recipeName,_ in pairs(newLocale) do
				out=out.."\""..recipeName.."\", "
			end
			out=out.."})"
			game.write_file("hardCrafting-recipeWhitelist.txt",out)
		end
		global.hardCrafting.localizationNotice = true
	end
end
