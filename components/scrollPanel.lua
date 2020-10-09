local cwd = string.sub(..., 1, string.len(...) - string.len('components.ScrollPanel'))

local class = require(cwd .. '.lib.middleclass')

local Panel = require(cwd .. '.components.panel')

local ScrollPanel = class('ScrollPanel', Panel)

local utils = require(cwd .. 'lib.utils')

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

function ScrollPanel:setClipSize (width, height)
	local x, y, _, _ = self.clipQuad:getViewport()

	self.clipRect.width = width or self.clipRect.width
	self.clipRect.height = height or self.clipRect.height

	self.clipQuad:setViewport(x, y, self.clipRect.width, self.clipRect.height, self.canvas:getDimensions())
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

function ScrollPanel:saveChildPositions (force)
	for _, v in ipairs(self.children) do
		if (v.beforeScrollBottomPos == nil and v.beforeScrollPos == nil) or force then
			v.beforeScrollPos = {
				x = v.realPosition.x,
				y = v.realPosition.y
			}

			v.beforeScrollBottomPos = {
				x = v.realBottomRight.x,
				y = v.realBottomRight.y
			}
		end
	end
end

function ScrollPanel:updateCanvas ()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	for _, v in ipairs(self.children) do
		print("pos", v.position.x, v.position.y)
		v:draw()
	end

	love.graphics.setCanvas()
end

function ScrollPanel:draw ()
	love.graphics.setColor(self.backgroundColor:to01())
	
	love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.clipRect.width, self.clipRect.height )
	love.graphics.setColor(1, 1, 1, 1)

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
		local scrollFactor = 5

		local _, _, clipWidth, clipHeight = self.clipQuad:getViewport()

		self.scroll.x = utils.clamp(self.scroll.x + x * scrollFactor, 0, clipHeight)
		self.scroll.y = utils.clamp(self.scroll.y - y * scrollFactor, 0, clipHeight)

		-- todo: move this to init or something
		self:saveChildPositions()

		for _, v in ipairs(self.children) do
			v.realPosition.x = v.beforeScrollPos.x + self.scroll.x
			v.realPosition.y = v.beforeScrollPos.y - self.scroll.y

			v.realBottomRight.x = v.beforeScrollBottomPos.x + self.scroll.x
			v.realBottomRight.y = v.beforeScrollBottomPos.y - self.scroll.y
		end

		self.clipQuad:setViewport(self.position.x + self.scroll.x, self.scroll.y, clipWidth, clipHeight)

	end
end

return ScrollPanel
