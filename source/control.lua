require "basic-lua-extensions"
require "defines"
require "controlFunctions"
require "find-raw-ingredients"
require "logging"
require "control.belt-sorter"

-- Init --
script.on_init(function()
	init()
end)

script.on_load(function()
	init()
end)

function init()
	if not global.hardCrafting then global.hardCrafting = {} end
	local hc = global.hardCrafting
	if not hc.version then hc.version = "0.3.0" end
	if not hc.incinerators then hc.incinerators = {} end
	if not hc.eincinerators then hc.eincinerators = {} end
	beltSorterInit()
end

script.on_event(defines.events.on_tick, function(event)
	updateBeltSorter(event)
	updateIncinerators()
	printOldMigrationNote()
	--printMissingRecipeLocalization()
end)

---------------------------------------------------
-- Building Entities
---------------------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
	entityBuilt(event)
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
	entityBuilt(event)
end)

function entityBuilt(event)
	local entity = event.created_entity
	beltSorterBuiltEntity(entity)
	local knownEntities = table.set({"incinerator","electric-incinerator"})
	if not knownEntities[entity.name] then
		return
	end
	if entity.name == "incinerator" then
		table.insert(global.hardCrafting.incinerators,entity)
	elseif entity.name == "electric-incinerator" then
		table.insert(global.hardCrafting.eincinerators,entity)
	end
end

---------------------------------------------------
-- Tick Incinerators
---------------------------------------------------

function updateIncinerators()
	if game.tick % 120 ~= 0 then return end
	for key,entity in pairs(global.hardCrafting.incinerators) do
		if entity.valid then
			reactivateIncineratorsInserters(entity,2)
		else
			global.hardCrafting.incinerators[key] = nil
		end
	end
	for key,entity in pairs(global.hardCrafting.eincinerators) do
		if entity.valid then
			reactivateIncineratorsInserters(entity,3)
		else
			global.hardCrafting.eincinerators[key] = nil
		end
	end
end

function reactivateIncineratorsInserters(entity,r)
	if not entity.is_crafting() then
		local pos = entity.position
		local search = {{pos.x-r,pos.y-r}, {pos.x+r,pos.y+r}}
		local inserters = entity.surface.find_entities_filtered{area = search, type= "inserter"}
		for _,inserter in pairs(inserters) do
			if inserter.active then
				--quickly toggle inserter active state, will recheck whether item can be inserted
				inserter.active = false
				inserter.active = true
			end
		end
	end
end

---------------------------------------------------
-- various
---------------------------------------------------

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

function printOldMigrationNote()
	local hc = global.hardCrafting
	if game.tick % 60 ~= 0 then return end
	if hc and (hc.signalReceiver or hc.signalRequester) then
		local showMsg = false
		if hc.signalReceiver and #hc.signalReceiver > 0 then showMsg = true end
		if hc.signalRequester and #hc.signalRequester > 0 then showMsg = true end

		if game and not global.hardCrafting.updateTick then
			global.hardCrafting.updateTick = game.tick
		end
		if game.tick - global.hardCrafting.updateTick > 60*5 then
			if showMsg then
				PlayerPrint("hardCrafting: Please note that the signalReceiver has been removed from hardCrafting.")
				PlayerPrint("If you still want to use it you can download the separated mod neatLogistics at: ")
				PlayerPrint("https://github.com/judos/neatLogistics/releases")
			end
			global.hardCrafting.signalReceiver = nil
			global.hardCrafting.signalRequester = nil
			global.hardCrafting.updateTick = nil
		end
	end
end
