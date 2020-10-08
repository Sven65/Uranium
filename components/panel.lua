local cwd = string.sub(..., 1, string.len(...) - string.len('components.panel'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Panel = class('Panel', GUIElement)

function Panel:initialize (position, size, backgroundColor)
	GUIElement.initialize(self, position, size)

	self.backgroundColor = backgroundColor
end

function Panel:draw ()
	GUIElement.draw(self)

	love.graphics.setColor(self.backgroundColor:to01())

	love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.size.width, self.size.height )
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.push()
	love.graphics.translate(self.position.x, self.position.y)

	for _, v in ipairs(self.children) do
		v:draw()
	end
	
	love.graphics.pop()
end

return Panel
