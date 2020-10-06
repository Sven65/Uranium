local bit = require 'bit'

local Color = {}

local Meta = {
	__index = Color
}

function Color.new (r, g, b)
	local color = {}

	color.r = r
	color.g = g
	color.b = b

	return setmetatable(color, Meta)
end

function Color:toHex ()
	return ("%.2X"):format(self.r) .. ("%.2X"):format(self.g) .. ("%.2X"):format(self.b)
end


-- Creates a new color from a hex color
-- @tparam string hex The hex to convert
-- @treturn Color the created color
function Color.fromHex (hex)
	local colorString = hex:gsub("^#", "0x")

	local colorNumber = tonumber(colorString)

	local color = {}
	
	color.r = bit.band(bit.rshift(colorNumber, 16), 0xFF)
	color.g = bit.band(bit.rshift(colorNumber, 8), 0xFF)
	color.b = bit.band(colorNumber, 0xFF)

	return setmetatable(color, Meta)
end


-- Converts the color to a LÖVE compatible color
-- @tparam boolean returnTable If the color should return a table. Defaults to true.
-- @treturn number The amount of red
-- @treturn number The amount of green
-- @treturn number The amount of blue
-- @treturn number The alpha
function Color:to01 (returnTable)
	returnTable = returnTable or true

	local r, g, b = love.math.colorFromBytes(self.r, self.g, self.b)

	if not returnTable then
		return r, g, b, 1
	end

	return { r, g, b, 1 }
end

return setmetatable(Color, {
	__call  = function(_, ...) return Color.new(...) end,
})
