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

function Row:calculatePositions ()
	if self.align == 'center' then
		local startX = self.position.x / 2 - self.size.width / 2 - (self.padding * (#self.children - 1))

		for i, v in ipairs(self.children) do
			local eWidth = v:getWidth()

			local xPos = startX + eWidth * i + self.padding * i

			v:setPosition(xPos, self.position.y - self.size.height)
		end
	elseif self.align == 'default' then
		-- Let children handle align

		for _, v in ipairs(self.children) do
			local eWidth = v:getWidth()
			local xPos = 0

			if v.align == 'right' then
				xPos = self.position.x / 2 + (eWidth) - v.padding.right
			elseif v.align == 'left' then
				xPos = self.position.x / 2 + v.padding.left
			end

			v:setPosition(xPos, self.position.y - self.size.height)
		end
	end
end

function Row:addChild (child)
	table.insert(self.children, child)
	self:calculateSize()
	self:calculatePositions()
end

function Row:draw ()
	GUIElement.draw(self)

	for _, v in ipairs(self.children) do
		v:draw()
	end
end

function Row:update (dt)
	for _, v in ipairs(self.children) do
		v:update(dt)
	end
end

return Row
