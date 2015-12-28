require("prototypes.antenna")
require("prototypes.rotor")
require("prototypes.electro-magnet")

-- Engine unit
data.raw["recipe"]["engine-unit"].energy_required = 10
data.raw["recipe"]["engine-unit"].ingredients = {
	{type="fluid", name= "lubricant", amount = 2},
	{"pipe",1},
	{"iron-gear-wheel",1},
	{"steel-plate",1}
}

-- Electric engine unit
data.raw["recipe"]["electric-engine-unit"].energy_required = 10
data.raw["recipe"]["electric-engine-unit"].ingredients = {
	{"electro-magnet",2},
	{"electronic-circuit",1},
	{"copper-cable",1},
	{"steel-plate",1}
}

-- Robot frame
data.raw["recipe"]["flying-robot-frame"].energy_required = 10
data.raw["recipe"]["flying-robot-frame"].ingredients = {
	{"electric-engine-unit", 1},
  {"battery", 2},
  {"rotor", 4},
  {"copper-cable", 4}
}

-- Robots
data.raw["recipe"]["logistic-robot"].energy_required = 5
data.raw["recipe"]["logistic-robot"].ingredients = {
	{"flying-robot-frame", 1},
  {"advanced-circuit", 1},
	{"antenna",1}
}
data.raw["recipe"]["construction-robot"].energy_required = 5
data.raw["recipe"]["construction-robot"].ingredients = {
	{"flying-robot-frame", 1},
  {"electronic-circuit", 1},
	{"antenna",1}
}
