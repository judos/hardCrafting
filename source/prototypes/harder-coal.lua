-- Requirement: --
require "prototypes.pulverizer"
require "basic-lua-extensions"

-- Minable ressources: --
data.raw["resource"]["coal"].minable.result = nil
data.raw["resource"]["coal"].minable.results = {
	ressourceItemMinMaxProb("coal", 1, 1, 0.8),
	ressourceItemMinMaxProb("coal-dust", 1, 2, 0.2)
}

-- Item: --
local timeToPulverizeCoal = 2
local powerPulverizer = 0.140 --MW

addItem("coal-dust","raw-material","b2[coal]",100)
local fuelValueCoal = data.raw.item.coal.fuel_value or "8MJ"
-- get fuelValue in MJ as number:
fuelValueCoal = tonumber(fuelValueCoal:sub(1,fuelValueCoal:len()-2))
-- set fuelValue for coal dust:
local fuelValueCoalDust = (fuelValueCoal+ timeToPulverizeCoal*powerPulverizer) / 5 * 1.2
fuelValueCoalDust = round(fuelValueCoalDust,1)
data.raw["item"]["coal-dust"].fuel_value = tostring(fuelValueCoalDust).."MJ"

-- Recipes: --
--       item Name     category   subgroup     time   							 ingredients     products		order
addRecipe("coal-dust","pulverizer","raw-material",timeToPulverizeCoal,{{"coal",1}},{{"coal-dust",5}},"b[coal]2")
addTechnologyUnlocksRecipe("pulverizer","coal-dust")
