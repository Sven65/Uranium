local cwd = string.sub(..., 1, string.len(...) - string.len('components.panel'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Panel = class('Panel', GUIElement)

local inspect = require 'lib.inspect'

function Panel:initialize (position, size, backgroundColor)
	GUIElement.initialize(self, size, position)

	self.backgroundColor = backgroundColor
end

function Panel:draw ()
	GUIElement.draw(self)

	love.graphics.setColor(self.backgroundColor:to01())

	love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.size.width, self.size.height )
	love.graphics.setColor(1, 1, 1, 1)

	for i, v in ipairs(self.children) do
		v:draw()
	end
end

return Panel
