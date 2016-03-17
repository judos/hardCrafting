function beltSorterInit()
	if not global.hardCrafting.beltSorter then	
		global.hardCrafting.beltSorter = {}
	end
end

function beltSorterBuiltEntity(entity)
	if entity.name == "belt-sorter" then	
		table.insert(global.hardCrafting.beltSorter, entity)
	end
end

------------------------------------------------------------

local searchPriority = {{0,-1},{-1,0},{1,0},{0,1}}

-- checks whether relative position is a neighbor of the belt-sorter
local function isValidBeltDirection(x,y)
	return math.abs(x)+math.abs(y) == 1
end

-- returns the direction on which side the belt is located relative to x,y, assuming they are neighbors
local function beltSide(x,y,belt)
	local dx = belt.position.x-x
	local dy = belt.position.y-y
	if dx==-1 then
		return defines.direction.west
	elseif dx==1 then
		return defines.direction.east
	elseif dy==-1 then
		return defines.direction.north
	elseif dy==1 then
		return defines.direction.south
	end
end

local function isInputBelt(x,y,belt)
	local direction = belt.direction
	local side = beltSide(x,y,belt)
	return side == (direction + 4)%8 -- must be 180°
end

function updateBeltSorter(event)
	-- update every 10 ticks
	if game.tick % 10 ~= 0 then return end
	for k,beltSorter in pairs(global.hardCrafting.beltSorter) do
		if not beltSorter.valid then
			global.hardCrafting.beltSorter[k] = nil
		else
			local surface = beltSorter.surface
			local x = beltSorter.position.x
			local y = beltSorter.position.y
			--info("updating belt: "..x..","..y)
			-- search for input / output belts
			local input = {}
			local output = {}
			--info("searching for belts...")
			for _,searchPos in pairs(searchPriority) do
				local searchPoint = { x + searchPos[1], y + searchPos[2] }
				local beltCandidates = surface.find_entities_filtered{area = {searchPoint, searchPoint}, type= "transport-belt"}
				for _,belt in pairs(beltCandidates) do
					if isValidBeltDirection(belt.position.x-x,belt.position.y-y) then
						--info("found belt at: "..(belt.position.x-x) .." "..(belt.position.y-y))
						if isInputBelt(x,y,belt) then
							table.insert(input,belt)
						else
							table.insert(output,belt)
						end
					end
				end
			end
			
			--debug("input belts: "..#input)
			--debug("output belts: "..#output)
			
			-- Build filter table from inventory
			local filter = {} -- direction = {itemName, ..} filter
			local slotIndexToDirection = {[0]=defines.direction.north, [1]=defines.direction.west,
																		[2]=defines.direction.east, [3]=defines.direction.south}
			local inventory = beltSorter.get_inventory(defines.inventory.chest)
			for i = 1,40 do
				if inventory[i]~=nil and inventory[i].valid_for_read then
					local slotRow = slotIndexToDirection[math.floor((i-1)/10)]
					if filter[slotRow] == nil then filter[slotRow]={} end
					table.insert(filter[slotRow],inventory[i].name)
				end
			end
			
			
			-- Distribute items on output belts
			for _,belt in pairs(output) do
				local beltSide = beltSide(x,y,belt)
				--info("for output belt: "..serpent.block(belt.position))
				for line=1,2 do
					local beltLine = belt.get_transport_line(line)
					if beltLine.can_insert_at_back() and filter[beltSide]~=nil then
						local canInsert = true
						for _,itemName in pairs(filter[beltSide]) do
							--info("checking item: "..itemName)
							
							for _,inputBelt in pairs(input) do
								if not inputBelt then warn(input) end
								--info(inputBelt)
								local rel = inputBelt.position
								--info(rel)
								local relX = rel.x - x
								local relY = rel.y - y
								--info("checking input: "..relX..","..relY)
								for line=1,2 do
									local beltLineInput = inputBelt.get_transport_line(line)
									local content = beltLineInput.get_contents()
									if content[itemName]~=nil then
										local itemStack = {name=itemName,count=1}
										if beltLineInput.remove_item(itemStack) then
											beltLine.insert_at_back(itemStack)
											canInsert = beltLine.can_insert_at_back()
										end
									end
									if not canInsert then break end
								end
								if not canInsert then break end
							end
							if not canInsert then break end
						end
					end
				end
			end
		end
	end
end
