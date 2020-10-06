local cwd = string.sub(..., 1, string.len(...) - string.len('components.ScrollPanel'))

local class = require(cwd .. '.lib.middleclass')

local Panel = require(cwd .. '.components.panel')

local ScrollPanel = class('ScrollPanel', Panel)

function ScrollPanel:initialize (position, size, backgroundColor, clipRect)
	Panel.initialize(self, position, size, backgroundColor)

	self.scroll = {
		x = 0,
		y = 0,
	}

	self.clipRect = clipRect

	self:setSize(nil, clipRect.height)
end

function ScrollPanel:draw ()
	love.graphics.setScissor(self.position.x, self.position.y, self.size.width, self.clipRect.height)
	Panel.draw(self)

	love.graphics.setScissor()
end

return ScrollPanel
