--- A panel that contains other elements
-- @module Slider

local cwd = string.sub(..., 1, string.len(...) - string.len('components.slider'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Slider = class('Slider', GUIElement)


--- Creates a new Slider
-- @tparam Position position The position of the label
-- @tparam Size size The size of the panel
-- @tparam Color backgroundColor The background color of the panel
-- @treturn Label
function Slider:initialize (position, size, colors)
	GUIElement.initialize(self, position, size)

	self.colors = colors

	self.isClicked = false

	self.progress = 0
	self.max = 100
end

--- Sets the progress of the slider
-- @tparam number progress The new progress of the slider
function Slider:setProgress (progress)
	self.progress = progress
end

--- Sets the maximum value of the slider
-- @tparam number max The new maximum of the slider
function Slider:setMax (max)
	self.max = max
end

function Slider:onPreLeftClick (x)
	self.isClicked = true

	self.progress = self:calculateProgressFromX(x)

	if type(self.onValueChanged) == 'function' then
		self.onValueChanged(self, self.progress)
	end
end

function Slider:onLeftClick (x)
	self.progress = self:calculateProgressFromX(x)

	self.isClicked = false

	if type(self.onValueChanged) == 'function' then
		self.onValueChanged(self, self.progress)
	end
end

function Slider:calculateProgressFromX (x)
	local startPoint = self.realPosition.x

	local dragWidth = x - startPoint

	local dragPercentage = (dragWidth / self.size.width) * 100

	return dragPercentage
end

function Slider:onDrag(x)
	if not self.isClicked then return end

	self.progress = self:calculateProgressFromX(x)

	if type(self.onValueChanged) == 'function' then
		self.onValueChanged(self, self.progress)
	end
end

function Slider:mousereleased (x, y, button)
	GUIElement.mousereleased(self, x, y, button)

	self.isClicked = false
end


function Slider:getFillWidth ()
	local fillPercentage = (self.progress / self.max) * 100

	local fillWidth = (fillPercentage * self.size.width) / 100

	return fillWidth
end

-- Draws the slider
function Slider:draw ()
	GUIElement.draw(self)

	love.graphics.setColor(self.colors.background:to01())

	love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.size.width, self.size.height )

	love.graphics.setColor(self.colors.fill:to01())

	-- Draw fill

	local fillWidth = self:getFillWidth()

	love.graphics.rectangle( 'fill', self.position.x, self.position.y, fillWidth, self.size.height )

	love.graphics.setColor(1, 1, 1, 1)
end

return Slider
