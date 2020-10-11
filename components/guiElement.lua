local cwd = string.sub(..., 1, string.len(...) - string.len('components.guiElement'))

local class = require(cwd .. '.lib.middleclass')

local Utils = require(cwd..'.lib.utils')

local GUIElement = class('GUIElement')


-- Creates a new GUIElement
-- @tparam Position position The position of the elenent
-- @tparam Size size The size of the element
-- @tparam ?string align The alignment of the element
-- @tparam ?Padding padding The padding of the element
function GUIElement:initialize (position, size, align, padding)
	self.size = size
	self.unscaledSize = {
		width = size.width,
		height = size.height,
	}

	self.position = position

	self.unscaledPosition = {
		x = position.x,
		y = position.y
	}

	self.align = align or 'center'

	self.currentState = 'default'
	self.previousState = nil

	padding = padding or {}

	self.children = {}

	self.isChild = false

	self.padding = {
		left = padding.left or 0,
		right = padding.right or 0,
		top = padding.top or 0,
		bottom = padding.bottom or 0,
	}

	self.bottomRight = {
		x = position.x + size.width,
		y = position.y + size.height,
	}

	self.scale = {
		w = 1,
		h = 1,
	}
end

-- Calculates the bottom right coordinates for the element
function GUIElement:calculateBoxes ()
	self.bottomRight.x = self.position.x + self.size.width
	self.bottomRight.y = self.position.y + self.size.height
end

-- Sets the state for the element
-- @tparam ElementState state The new state
function GUIElement:setState (state)
	self.previousState = self.currentState
	self.currentState = state
end

-- Sets the size of the element
-- @tparam ?number width The width of the element
-- @tparam ?number height The height of the element
function GUIElement:setSize (width, height)
	self.size.width = width or self.size.width
	self.size.height = height or self.size.height
end

-- Scales the GUI element and children
-- @tparam ?number wScale The width scale
-- @tparam ?number hScale The height scale
-- @tparam ?boolean scaleChildren If the elements children should also be scaled, defaults to true
function GUIElement:setScale (wScale, hScale, scaleChildren)
	if scaleChildren == nil then scaleChildren = true end

	self.scale.w = wScale or self.scale.w
	self.scale.h = hScale or self.scale.h

	local scaledWidth = self.unscaledSize.width * wScale
	local scaledHeight = self.unscaledSize.height * hScale

	local scaledXPos = self.unscaledPosition.x * wScale
	local scaledYPos = self.unscaledPosition.y * hScale

	self:setSize(scaledWidth, scaledHeight)

	self:setPosition(scaledXPos, scaledYPos)

	if scaleChildren then
		self:doRecursive(self.children, 'setScale', wScale, hScale, scaleChildren)
	end

	self:calculateRealPositions()

	if type(self.afterScaled) == 'function' then
		self:afterScaled()
	end
end

-- Sets the elements padding
-- @tparam ?number left The left padding
-- @tparam ?number right The right padding
-- @tparam ?number top The top padding
-- @tparam ?number bottom The bottom padding
function GUIElement:setPadding (left, right, top, bottom)
	self.padding.left = left or self.padding.left
	self.padding.right = right or self.padding.right
	self.padding.top = top or self.padding.top
	self.padding.bottom = bottom or self.padding.bottom
end

-- Sets the elements align
-- @tparam ?string align The new alignment for the element
function GUIElement:setAlign (align)
	self.align = align or 'center'
end

-- Gets the elements size
-- @treturn number The element width
-- @treturn number The element height
function GUIElement:getSize ()
	return self.size.width, self.size.height
end

-- Gets the elements width
-- @treturn number The element width
function GUIElement:getWidth ()
	return self.size.width
end

-- Gets the elements height
-- @treturn number The element height
function GUIElement:getHeight ()
	return self.size.height
end

-- Sets the elements position
-- @tparam ?number x The new x position
-- @tparam ?number y The new y position
function GUIElement:setPosition (x, y)
	self.position.x = x or self.position.x
	self.position.y = y or self.position.y

	self.unscaledPosition.x = self.unscaledPosition.x or x
	self.unscaledPosition.y = self.unscaledPosition.y or y

	self:calculateBoxes()
end

-- Sets the elements unscaled position
-- @tparam ?number x The new x position
-- @tparam ?number y The new y position
function GUIElement:setUnscaledPosition (x, y)
	self.unscaledPosition.x = x or self.unscaledPosition.x
	self.unscaledPosition.y = y or self.unscaledPosition.y
end

-- Draws the GUI Element
function GUIElement:draw()
	if self.showBoxes then
		love.graphics.setColor(0, 1, 0, 1)

		love.graphics.rectangle(
			'line',
			self.position.x,
			self.position.y,
			self.bottomRight.x - self.position.x,
			self.bottomRight.y - self.position.y
		)

		love.graphics.setColor(1, 0, 0, 1)

		love.graphics.rectangle(
			'line',
			self.realPosition.x,
			self.realPosition.y,
			self.realBottomRight.x - self.realPosition.x,
			self.realBottomRight.y - self.realPosition.y
		)

		love.graphics.setColor(0, 0, 1, 1)

		love.graphics.rectangle(
			'line',
			self.unscaledPosition.x,
			self.unscaledPosition.y,
			self.bottomRight.x - self.unscaledPosition.x,
			self.bottomRight.y - self.unscaledPosition.y
		)

		love.graphics.setColor(1,1,1,1)
	end
end

-- Checks if the provided coordinates are within the bounds of the element
-- @tparam number x The x position to check
-- @tparam number y The y position to check
-- @treturn boolean If the given coordinates are within the bounds
function GUIElement:isHovering (x, y)
	return Utils.isInRect(self.realPosition.x, self.realPosition.y, self.realBottomRight.x, self.realBottomRight.y, x, y)
end

-- Adds a child to the GUI Element
-- @tparam GUIElement child The child to add
function GUIElement:addChild (child)
	child.isChild = true
	table.insert(self.children, child)
	self:calculateBoxes()
end

-- Calculates the screenspace (real) coordinates for the element
function GUIElement:calculateRealPositions ()
	love.graphics.push()

	love.graphics.translate(self.position.x, self.position.y)
	--love.graphics.scale(self.scale.w, self.scale.h)


	local screenX, screenY = love.graphics.transformPoint(0, 0)

	self.realPosition = {
		x = screenX,
		y = screenY,
	}

	self.realBottomRight = {
		x = screenX + self.size.width,
		y = screenY + self.size.height,
	}

	for _, v in ipairs(self.children) do
		v:calculateRealPositions()
	end

	love.graphics.pop()
end

-- Events

-- Executes the given function on the element and its children
-- @tparam GUIElement element The element to execute on
-- @tparam string func The function name to execute
function GUIElement:doRecursive(element, func, ...)
	for _, v in ipairs(element.children or element) do
		if v.children ~= nil and #v.children > 0 then
			v[func](v, ...)
			self:doRecursive(v.children, func, ...)
		else
			v[func](v, ...)
		end
	end
end

function GUIElement:mousemoved (x, y)
	self:doRecursive(self, 'mousemoved', x, y)
	
	if self:isHovering(x, y) then
		self:setState('hover')

		if type(self.onEnter) == 'function' then
			self.onEnter(self)
		end
	else
		self:setState('default')

		if type(self.onExit) == 'function' then
			self.onExit(self)
		end
	end

end

function GUIElement:mousepressed (x, y, button)
	self:doRecursive(self, 'mousepressed', x, y, button)

	if self.currentState == 'hover' then
		self:setState('clicked')

		if type(self.onPreLeftClick) == 'function' then
			self.onPreLeftClick(self)
		end
	end
end

function GUIElement:mousereleased (x, y, button)
	self:doRecursive(self, 'mousereleased', x, y, button)

	if self.currentState == 'clicked' then

		if self:isHovering(x, y) then
			self:setState('hover')

			if type(self.onLeftClick) == 'function' and self.currentState ~= 'clicked' then
				self.onLeftClick(self)
			end
		else
			self:setState('default')
		end
	end
end

function GUIElement:wheelmoved (x, y)
	if self.currentState ~= 'hover' then return end
end

function GUIElement:keypressed(key)
	if key == 'f6' then
		self.showBoxes = not self.showBoxes
	end
end

return GUIElement
