-- Requirement: --
require "prototypes.pulverizer"

-- Minable ressources: --
data.raw["resource"]["coal"].minable.result = nil
data.raw["resource"]["coal"].minable.results = {
	ressourceItemMinMaxProb("coal", 1, 1, 0.8),
	ressourceItemMinMaxProb("coal-dust", 1, 2, 0.2)
}

-- Item: --
local timeToPulverizeCoal = 2
local powerPulverizer = 0.140 --MW

addItem("coal-dust","by-products","a[coal]",100)
local fuelValueCoal = data.raw.item.coal.fuel_value or "8MJ"
-- get fuelValue in MJ as number:
fuelValueCoal = tonumber(fuelValueCoal:sub(1,fuelValueCoal:len()-2))
-- set fuelValue for coal dust:
local fuelValueCoalDust = (fuelValueCoal+ timeToPulverizeCoal*powerPulverizer) / 5 * 1.2
fuelValueCoalDust = round(fuelValueCoalDust,1)

local coalDust = data.raw.item["coal-dust"]
overwriteContent(coalDust,{
	fuel_value = tostring(fuelValueCoalDust).."MJ",
	fuel_category = "chemical",
	fuel_acceleration_multiplier = 1.2,
	fuel_top_speed_multiplier = 1.05
})

overwriteContent(data.raw.item["solid-fuel"],{
	fuel_acceleration_multiplier = 1.4,
	fuel_top_speed_multiplier = 1.15
})

overwriteContent(data.raw.item["raw-wood"],{
	fuel_acceleration_multiplier = 0.7,
	fuel_top_speed_multiplier = 0.7
})


-- Recipes: --
--       item Name     category   subgroup     time   							 ingredients     products		order
addRecipe("coal-dust","hc-pulverizer","by-products",timeToPulverizeCoal,{{"coal",1}},{{"coal-dust",5}},"a[coal]")
addTechnologyUnlocksRecipe("pulverizer","coal-dust")
