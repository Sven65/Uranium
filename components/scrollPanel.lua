--- A panel that can be scrolled
-- @module ScrollPanel

local cwd = string.sub(..., 1, string.len(...) - string.len('components.ScrollPanel'))

local class = require(cwd .. '.lib.middleclass')

local Panel = require(cwd .. '.components.panel')

local ScrollPanel = class('ScrollPanel', Panel)

local utils = require(cwd .. 'lib.utils')

--- Creates a new Scroll Panel
-- @tparam Position position The position of the scroll panel
-- @tparam Size size The size of the Scroll Panel
-- @tparam Color backgroundColor The background color for the scrollrect
-- @tparam Size clipRect The rect to use for limiting the drawing size
-- @treturn ScrollPanel
function ScrollPanel:initialize (position, size, backgroundColor, clipRect)
	Panel.initialize(self, position, size, backgroundColor)

	self.scroll = {
		x = 0,
		y = 0,
	}

	self.canvas = love.graphics.newCanvas(self.size.width, self.size.height)
	self:setSize(nil, clipRect.height)

	self.clipRect = clipRect

	self.clipQuad = love.graphics.newQuad(0, 0, self.clipRect.width, self.clipRect.height, self.canvas:getDimensions())

	self.forceChildPos = true

	self.maxYScroll = nil
end

--- Sets the clip size
-- @tparam number width The width of the clip
-- @tparam number height The height of the clip
function ScrollPanel:setClipSize (width, height)
	local x, y, w, h = self.clipQuad:getViewport()

	self.clipRect.width = width or w
	self.clipRect.height = height or h

	self.clipQuad:setViewport(x, y, self.clipRect.width, self.clipRect.height, self.canvas:getDimensions())
end

--- Sets the size of the scroll panel
-- @tparam number width The width of the panel
-- @tparam number height The height of the panel
function ScrollPanel:setSize(width, height)
	Panel.setSize(self, width, height)


	if self.clipQuad ~= nil and self.canvas ~= nil then
		self.canvas:release()

		self.canvas = love.graphics.newCanvas(self.size.width, self.size.height)
		local x, y, w, h = self.clipQuad:getViewport()

		local canvasWidth, canvasHeight = self.canvas:getDimensions()

		w = math.min(canvasWidth, w)
		h = math.min(canvasHeight, h)

		self.clipQuad:setViewport(x, y, w, h, canvasWidth, canvasHeight)

		if self.maxYScroll == nil then
			self.maxYScroll = self:calculateMaxY(h)
		end
	end
end

--- Saves the child positions for calculating scroll positions
-- @tparam ?boolean force If the save should overwrite regardless
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

	if self.forceChildPos then self.forceChildPos = false end
end

-- Updates the scroll panels canvas
function ScrollPanel:updateCanvas ()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	for _, v in ipairs(self.children) do
		v:draw()
	end

	love.graphics.setCanvas()
end

-- Draws the scroll panel
function ScrollPanel:draw ()
	if not self.display then return end

	love.graphics.setColor(self.backgroundColor:to01())

	love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.clipRect.width, self.clipRect.height)
	love.graphics.setColor(1, 1, 1, 1)


	love.graphics.draw(self.canvas, self.clipQuad, self.position.x, self.position.y)
end

--- Sets the scale of the scroll panel
-- @tparam number wScale The wScale
-- @tparam number hScale The hScale
function ScrollPanel:setScale (wScale, hScale)
	self.scale.w = wScale
	self.scale.h = hScale


	self.scroll.x = 0
	self.scroll.y = 0

	for _, v in ipairs(self.children) do
		v:calculateBoxes()
	end

	self:setSize(nil, self.size.height * hScale)

	local _, _, clipWidth, clipHeight = self.clipQuad:getViewport()

	self.clipQuad:setViewport(self.position.x + self.scroll.x, 0, clipWidth, clipHeight)

	self:updateCanvas()

	self.forceChildPos = true

	if self.maxYScroll == nil then
		self.maxYScroll = self:calculateMaxY(clipHeight)
	end
end

--- Calculates the maximum scroll height for the panel
-- @tparam number clipHeight The cliprect height
-- @treturn number The maximum scroll
function ScrollPanel:calculateMaxY (clipHeight)
	local canvasHeight = self.canvas:getHeight()

	if self.scale.h >= 1 then
		return (canvasHeight - clipHeight) * self.scale.h
	else
		return (canvasHeight - clipHeight) / self.scale.h
	end
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

		self.scroll.x = utils.clamp(self.scroll.x + x * scrollFactor, 0, clipWidth)
		self.scroll.y = utils.clamp(self.scroll.y - y * scrollFactor, 0, self.maxYScroll * self.scale.h)

		-- todo: move this to init or something
		self:saveChildPositions(self.forceChildPos)

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
