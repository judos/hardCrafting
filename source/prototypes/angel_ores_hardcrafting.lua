
-- add compatibility for Angel Ores mod

if data.raw["resource"]["infinite-copper-ore"] then
	data.raw["resource"]["infinite-copper-ore"].minable.result = nil
	data.raw["resource"]["infinite-copper-ore"].minable.results = data.raw["resource"]["copper-ore"].minable.results
end

if data.raw["resource"]["infinite-iron-ore"] then
	data.raw["resource"]["infinite-iron-ore"].minable.result = nil
	data.raw["resource"]["infinite-iron-ore"].minable.results = data.raw["resource"]["iron-ore"].minable.results
end
