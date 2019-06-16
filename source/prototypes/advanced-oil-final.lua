
if settings.startup["hardcrafting-hard-oil"].value == true then

	local crudeOil = data.raw.resource["crude-oil"]

	crudeOil.minable.fluid_amount = 10
	crudeOil.minable.required_fluid = "water"
	
	crudeOil.autoplace.coverage = crudeOil.autoplace.coverage / 3
	crudeOil.autoplace.peaks[1].noise_octaves_difference = crudeOil.autoplace.peaks[1].noise_octaves_difference - 0.5

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