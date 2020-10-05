local bit = require 'bit'

local utils = {}

--- Checks if a point is in a rect
-- @param topLeftX The x of the topleft point
-- @param topLeftY The y of the topleft point
-- @param bottomRightX The x of the bottomRight point
-- @param bottomRightY The y of the bottomRight point
-- @param pointX The X of the point to check
-- @param pointY The Y of the point to check
-- @return boolean
function utils.isInRect (topLeftX, topLeftY, bottomRightX, bottomRightY, pointX, pointY)
	return
			pointX >= topLeftX
		and pointX <= bottomRightX
		and pointY >= topLeftY
		and pointY <= bottomRightY
end

function utils.colorFromHex (hex)
	local colorString = hex:gsub("^#", "0x")

	local colorNumber = tonumber(colorString)

	local r = bit.band(bit.rshift(colorNumber, 16), 0xFF)
	local g = bit.band(bit.rshift(colorNumber, 8), 0xFF)
	local b = bit.band(colorNumber, 0xFF)

	return r / 255, g / 255, b / 255
end


return utils