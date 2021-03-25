if settings.startup["hardcrafting-complex-crafting-byproduct"].value == true then


	-- Item: --
	addItem("scrap-metal","by-products","z[scrap-metal]",50)
	
end

data:extend{
    {
        type = "sprite",
        name = fullModName .. "_scrap-metal",
        filename = "__" .. fullModName .. "__/graphics/icons/scrap-metal.png",
        size = 32,
    },

}
