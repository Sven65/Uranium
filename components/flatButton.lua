--- @module FlatButton

local cwd = string.sub(..., 1, string.len(...) - string.len('.components.flatButton'))

local min, mag, anisotropy = love.graphics.getDefaultFilter( )

love.graphics.setDefaultFilter('nearest', 'nearest')
local buttonImage = love.graphics.newImage(cwd:gsub('%.', '/') .. '/assets/FlatButton.png')
love.graphics.setDefaultFilter(min, mag, anisotropy)


local class = require(cwd .. '.lib.middleclass')

local Button = require(cwd .. '.components.button')

local FlatButton = class('FlatButton', Button)

--- Creates a new FlatButton
-- @tparam string text The button text
-- @tparam table colors The colors to use for the different button states
-- @field Color colors.default Default button color
-- @field Color colors.hover The color to use when the button is hovered
-- @field Color colors.click The color to use when the button is clicked
-- @tparam Position position The position of the button
-- @tparam ?Size size The size of the button
-- @tparam Font font The LÖVE font to use for the button
-- @treturn FlatButton
function FlatButton:initialize (text, colors, position, size, font)
	self.colors = colors

	if size == nil then
		local width, height = buttonImage:getDimensions()

		size = { width = width, height = height }
	end

	Button.initialize(self, text, position, size, font)
end

--- Gets the scale to use when drawing the button
-- @treturn number The width scale
-- @treturn number The height scale
function FlatButton:getDrawScale ()
	local width, height = buttonImage:getDimensions()

	return self.size.width / width, self.size.height / height
end

-- Draws the Button
function FlatButton:draw ()
	Button.draw(self)

	love.graphics.setColor(self.colors[self.currentState]:to01())

	local drawScaleX, drawScaleY = self:getDrawScale()


	love.graphics.draw(buttonImage, self.position.x, self.position.y, 0, drawScaleX, drawScaleY)

	love.graphics.setColor(1,1,1,1)

	if self.text ~= nil then
		love.graphics.draw(self.text, self.textPosition.x, self.textPosition.y)
	end
end



return FlatButton
