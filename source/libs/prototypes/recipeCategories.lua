require "libs.lua.table"

function addRecipeCategory(name)
	if not data.raw["recipe-category"][name] then
		data:extend({
			{
				type = "recipe-category",
				name = name
			}
		})
	end
end

-- Should be called only in data-final-fixes
function addCategorySupportsNew(category,newCategory)
	for group,entityList in pairs(data.raw) do
		local index = next(entityList)
		if entityList[index].crafting_categories then
			for name,entity in pairs(entityList) do
				if table.contains(entity.crafting_categories,category) then
					table.insert(entity.crafting_categories,newCategory)
				end
			end
		end
	end
end