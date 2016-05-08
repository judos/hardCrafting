-- See this very helpful topic as reference: https://forums.factorio.com/viewtopic.php?f=34&t=24007

local function addStyle(name,icon,iconSize)
	data.raw["gui-style"].default[name] = {
		type = "checkbox_style",
		parent = "checkbox_style",
		width = 34,
		height = 34,
		default_background = {
			filename = "__core__/graphics/gui.png",
			width = 36,
			height = 36,
			shift = { 0, -10 },
			x = 111
		},
		hovered_background = {
			filename = "__core__/graphics/gui.png",
			width = 36,
			height = 36,
			shift = { 0, -10 },
			x = 148
		},
		clicked_background = {
			filename = "__core__/graphics/gui.png",
			width = 36,
			height = 36,
			shift = { 0, -10 },
			x = 184
		},
		disabled_background = {
			filename = "__core__/graphics/gui.png",
			width = 36,
			height = 36,
			shift = { 0, -10 },
			x = 111
		},
		checked = {
			filename = icon,
			width = iconSize,
			height = iconSize,
			shift = { 0, -10 }
		}
	}
end

for typename, sometype in pairs(data.raw) do
	local _, object = next(sometype)
	if object.stack_size or typename == "fluid" then
		for name, item in pairs(sometype) do
			if item.icon then
				addStyle("item-"..name,item.icon,32)
			end
		end
	end
end
addStyle("item-empty","__hardCrafting__/graphics/entity/empty.png",1)

data.raw["gui-style"].default["table-no-border"] = {
	type = "table_style",
	parent = "table_style",
	cell_padding = 0,
	horizontal_spacing = 0,
	vertical_spacing = 0,
}
