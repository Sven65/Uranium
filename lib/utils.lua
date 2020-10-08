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

function utils.clamp (value, min, max)
	return math.max(min, math.min(max, value))
end

return utils