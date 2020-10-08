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

	self.clipRect = clipRect

	self.clipQuad = love.graphics.newQuad(0, 0, self.clipRect.width, self.clipRect.height, self.canvas:getDimensions())
end

function ScrollPanel:setSize(width, height)
	Panel.setSize(self, width, height)

	if self.clipQuad ~= nil and self.canvas ~= nil then

		self.canvas:release()
		self.canvas = love.graphics.newCanvas(self.size.width, self.size.height)
		local x, y, w, h = self.clipQuad:getViewport()
		self.clipQuad:setViewport(x, y, w, h, self.canvas:getDimensions())
	end
end

function ScrollPanel:updateCanvas ()
	love.graphics.setCanvas(self.canvas)

	for _, v in ipairs(self.children) do
		v:draw()
	end

	love.graphics.setColor(1,1,1,1)

	love.graphics.setCanvas()
end

function ScrollPanel:draw ()
	love.graphics.setColor(self.backgroundColor:to01())
	
	love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.clipRect.width, self.clipRect.height )
	love.graphics.setColor(0, 0, 0, 1)

	love.graphics.draw(self.canvas, self.clipQuad, self.position.x, self.position.y)
end

-- Events

function ScrollPanel:mousemoved (x, y)
	Panel.mousemoved(self, x, y)
	if self.currentState == 'hover' then
		self:updateCanvas()
	end
end

function ScrollPanel:wheelmoved (x, y)
	Panel.wheelmoved(self, x, y)
	if self.currentState == 'hover' then
		self.scroll = {
			x = self.scroll.x + x * 2,
			y = self.scroll.y - y * 2
		}

		local _, _, clipWidth, clipHeight = self.clipQuad:getViewport()

		self.clipQuad:setViewport(self.position.x + self.scroll.x, self.scroll.y, clipWidth, clipHeight)

	end
end

return ScrollPanel
