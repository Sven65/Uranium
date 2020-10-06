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
	self.canvas = love.graphics.newCanvas()

	self.clipRect = clipRect

	self.clipQuad = love.graphics.newQuad(self.position.x, self.position.y, self.clipRect.width, self.clipRect.height, self.canvas:getDimensions())


	print (self.clipRect.width, self.clipRect.height)
end

function ScrollPanel:setCanvasHeight (height)
	self.clipQuad = love.graphics.newQuad(self.position.x, self.position.y, self.clipRect.width, self.clipRect.height, self.canvas:getDimensions())
end

function ScrollPanel:updateCanvas ()
	love.graphics.setCanvas(self.canvas)

	Panel.draw(self)

	love.graphics.setCanvas()
end

function ScrollPanel:draw ()
	love.graphics.draw(self.canvas, self.clipQuad, self.position.x, self.position.y)
end

-- Events

function ScrollPanel:mousemoved (x, y)
	Panel.mousemoved(self, x, y)
	if self.currentState == 'hover' then
		self:updateCanvas()
	end
end

return ScrollPanel
