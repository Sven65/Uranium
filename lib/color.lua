------------
-- Utilities for working with colors more easily

local bit = require 'bit'

local Color = {}

local Meta = {
	__index = Color
}

--- Creates a new color from RGB space
-- Please note that this uses values in the range of 0 to 255.
-- @tparam number r The red component of the color
-- @tparam number g The green component of the color
-- @tparam number b The red component of the color
-- @treturn Color The new color
function Color.new (r, g, b)
	local color = {}

	color.r = r
	color.g = g
	color.b = b

	return setmetatable(color, Meta)
end

--- Converts the color to a hex string
-- @treturn string The color in hex
function Color:toHex ()
	return ("%.2X"):format(self.r) .. ("%.2X"):format(self.g) .. ("%.2X"):format(self.b)
end


--- Creates a new color from a hex color
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


--- Converts the color to a LÖVE compatible color, in the 0 to 1 range
-- @tparam boolean returnTable If the color should return a table, default true
-- @treturn[1] number The red component
-- @treturn[1] number The green component
-- @treturn[1] number The blue component
-- @treturn[1] number The alpha component
-- @return[2] {number, ...} A table of the components
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
