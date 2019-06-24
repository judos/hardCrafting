resource_autoplace = require("__base__.prototypes.entity.demo-resource-autoplace");

if settings.startup["hardcrafting-hard-oil"].value == true then

	local crudeOil = data.raw.resource["crude-oil"]

	crudeOil.minable.fluid_amount = 10
	crudeOil.minable.required_fluid = "water"

	data.raw["mining-drill"].pumpjack.input_fluid_box = {
		production_type = "input-output",
		pipe_picture = assembler2pipepictures(),
		pipe_covers = pipecoverspictures(),
		base_area = 1,
		height = 2,
		base_level = -1,
		pipe_connections =
		{
			{ position = {-2, 0}, {0,2}, {2,0} },
		}
	}

end