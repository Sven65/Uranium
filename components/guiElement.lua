local cwd = string.sub(..., 1, string.len(...) - string.len('components.guiElement'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = class('GUIElement')

local showBoxes = false

function GUIElement:initialize (size, position, align, padding)
	self.size = size
	self.position = position

	self.align = align or 'center'

	self.currentState = 'default'
	self.previousState = nil

	padding = padding or {}

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
end

function GUIElement:calculateBoxes ()
	self.bottomRight = {
		x = self.position.x + self.size.width,
		y = self.position.y + self.size.height,
	}
end

function GUIElement:setState (state)
	self.previousState = self.currentState
	self.currentState = state
end

function GUIElement:setSize (width, height)
	self.size = {
		width = width or self.size.width,
		height = height or self.size.height,
	}
end

function GUIElement:setPadding (left, right, top, bottom)
	self.padding = {
		left = left or self.padding.left,
		right = right or self.padding.right,
		top = top or self.padding.top,
		bottom = bottom or self.padding.bottom,
	}
end

function GUIElement:setAlign (align)
	self.align = align or 'center'
end

function GUIElement:getSize ()
	return self.size.width, self.size.height
end

function GUIElement:getWidth ()
	return self.size.width
end

function GUIElement:getHeight ()
	return self.size.height
end

function GUIElement:setPosition (x, y)
	self.position = {
		x = x or self.position.x,
		y = y or self.position.y,
	}

	self:calculateBoxes()
end

function GUIElement:update (dt) end


function GUIElement:draw()
	if showBoxes then
		love.graphics.setColor(0, 1, 0, 1)

		love.graphics.rectangle(
			'line',
			self.position.x,
			self.position.y,
			self.bottomRight.x - self.position.x,
			self.bottomRight.y - self.position.y
		)

		love.graphics.setColor(1,1,1,1)
	end
end

function GUIElement:isHovering (x, y)
	return Utils.isInRect(self.position.x, self.position.y, self.bottomRight.x, self.bottomRight.y, x, y)
end

-- Events

function love:keypressed (key)
	if key == 'f6' then
		showBoxes = not showBoxes
	end
end

function GUIElement:mousemoved (x, y)
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
	if self.currentState == 'hover' then
		self:setState('clicked')

		if type(self.onPreLeftClick) == 'function' then
			self.onPreLeftClick(self)
		end
	end
end

function GUIElement:mousereleased (x, y, button)
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


return GUIElement
