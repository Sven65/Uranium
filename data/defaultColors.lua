local cwd = string.sub(..., 1, string.len(...) - string.len('data.defaultColors'))

local Color = require(cwd .. '.lib.color')

return {
	background = Color.fromHex('#ff09395d'),
	black = Color.fromHex('#000000'),
	white = Color.fromHex('#ffffff'),
	blueGrey = Color.fromHex('#d1d8e0'),
	blueHorizon = Color.fromHex('#4b6584'),
	twinkleBlue = Color.fromHex('#d1d8e0'),
	red = Color.fromHex('#ff0000'),
}