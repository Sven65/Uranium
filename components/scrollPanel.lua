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

	self:setSize(nil, clipRect.height)
	self.canvas = love.graphics.newCanvas(self.size.width, self.size.height)

	self.clipQuad = love.graphics.newQuad(0, 0, self.size.width, clipRect.height, self.size.width, self.size.height)

end

function ScrollPanel:setCanvasHeight (height)
	print(self.size.width, height)
	self.canvas = love.graphics.newCanvas(self.size.width, height)

	self.clipQuad = love.graphics.newQuad(0, 0, self.canvas:getWidth(), 200, self.canvas:getDimensions())
end

function ScrollPanel:updateCanvas ()
	love.graphics.setCanvas(self.canvas)

	Panel.draw(self)

	love.graphics.setCanvas()
end

function ScrollPanel:draw ()
	love.graphics.draw(self.canvas, self.clipQuad, 0, 0)
end

return ScrollPanel
