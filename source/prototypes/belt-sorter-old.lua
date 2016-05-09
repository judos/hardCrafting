-- Entity
local beltSorter = deepcopy(data.raw["container"]["wooden-chest"])
beltSorter.name = "belt-sorter"
beltSorter.minable.result = "belt-sorter"
beltSorter.inventory_size = 40
beltSorter.icon = "__hardCrafting__/graphics/icons/belt-sorter.png"
beltSorter.picture.filename="__hardCrafting__/graphics/entity/belt-sorter.png"
beltSorter.fuel_value = nil
beltSorter.order = "zzz"
data:extend({	beltSorter })
