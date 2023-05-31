local railloader = {}

function railloader.IsValid()
    if script.active_mods["railloader"] == nil then
            return false
    end

    log {"activating railloader-support"}

    return true
end

function railloader.AddBulkItem(item) --
    local result = remote.call("railloader", "add_bulk_item", item)
    return result
end

return railloader
