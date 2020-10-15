--- A simple text label
-- @module Label

local cwd = string.sub(..., 1, string.len(...) - string.len('components.label'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Label = class('Label', GUIElement)

--- Creates a new Label
-- @tparam Font font The LÖVE font to use for the label
-- @tparam string text The label text
-- @tparam Position position The position of the label
-- @treturn Label
function Label:initialize (font, text, position)
	self.text = love.graphics.newText(font, text)

	local width, height = self.text:getDimensions()

	GUIElement.initialize(self, position, { width = width, height = height })
end

--- Sets the text of the label
-- @tparam string text The new text for the label
function Label:setText (text)
	self.text:set(text)

	local width, height = self.text:getDimensions()

	self:setSize(width, height)
end

-- Draws the label
function Label:draw ()
	GUIElement.draw(self)

	love.graphics.draw(self.text, self.position.x, self.position.y)
end

return Label
