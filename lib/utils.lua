------------
-- Various utilities and shared code for Uranium
local utils = {}

--- Checks if a point is in a rect
-- @tparam number topLeftX The x of the topleft point
-- @tparam number topLeftY The y of the topleft point
-- @tparam number bottomRightX The x of the bottomRight point
-- @tparam number bottomRightY The y of the bottomRight point
-- @tparam number pointX The X of the point to check
-- @tparam number pointY The Y of the point to check
-- @treturn boolean If the point is within the rect
function utils.isInRect (topLeftX, topLeftY, bottomRightX, bottomRightY, pointX, pointY)
	return
			pointX >= topLeftX
		and pointX <= bottomRightX
		and pointY >= topLeftY
		and pointY <= bottomRightY
end

--- Clamps a value between a minimum and a maximum
-- @tparam number value The value to clamp
-- @tparam number min The minimum value
-- @tparam number max The maximum value
-- @treturn number The clamped value
function utils.clamp (value, min, max)
	return math.max(min, math.min(max, value))
end

return utils