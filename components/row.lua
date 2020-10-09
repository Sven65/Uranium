local cwd = string.sub(..., 1, string.len(...) - string.len('components.row'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Row = class('Row', GUIElement)

function Row:initialize (position, padding)
	GUIElement.initialize(self, position, { width = 0, height = 0})

	self.children = {}
	self.position = position
	self.padding = padding or 0
end

function Row:calculateSize ()
	local width = 0
	local maxHeight = 0

	for _, v in ipairs(self.children) do
		local eWidth, eHeight = v:getSize()

		width = width + eWidth

		maxHeight = math.max(maxHeight, eHeight)
	end

	self:setSize(width, maxHeight)
end


function Row:addChild (child)
	table.insert(self.children, child)
	self:calculateSize()
end

function Row:draw ()
	GUIElement.draw(self)

	love.graphics.push()

	love.graphics.translate(self.position.x, self.position.y)

	for _, v in ipairs(self.children) do
		v:draw()
	end

	love.graphics.pop()
end

function Row:update (dt)
	for _, v in ipairs(self.children) do
		v:update(dt)
	end
end

return Row
