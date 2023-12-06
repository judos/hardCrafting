local railloader = {}

function railloader.IsValid()
    if script.active_mods["railloader"] == nil and script.active_mods["railloader-MXO"] == nil then
            return false
    end

    log { "activating railloader-support" }

    return true
end

function AddBulkItem(item) --
    local result = remote.call("railloader", "add_bulk_item", item)
    return result
end

function railloader.AddBulkItems()
	if railloader.IsValid() then
		AddBulkItem("dirt")

		AddBulkItem("gravel")
		AddBulkItem("gravel-pile")

		AddBulkItem("coal-dust")

		AddBulkItem("iron-slag")
		AddBulkItem("iron-nugget")
		AddBulkItem("iron-nugget")
		AddBulkItem("crushed-iron")
		AddBulkItem("pulverized-iron")

		AddBulkItem("steel-dust")

		AddBulkItem("copper-sludge")
		AddBulkItem("copper-dust")
		AddBulkItem("sufur-dust")
		AddBulkItem("copper-sulfat")
	end
end

return railloader
