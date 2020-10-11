local cwd = string.sub(..., 1, string.len(...) - string.len('components.button'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Button = class('Button', GUIElement)

-- Creates a new Button
-- @tparam string text The button text
-- @tparam Position position The position of the button
-- @tparam ?Size size The size of the button
-- @tparam Font The LÖVE font to use for the button
-- @treturn Button
function Button:initialize (text, position, size, font)
	font = font or love.graphics.getFont()

	self.font = font

	self.text = love.graphics.newText(font, text)

	if size == nil then
		local width, height = self.text:getDimensions()

		size = {
			width = width,
			height = height,
		}
	end

	GUIElement.initialize(self, position, size)

	self.textPosition = {
		x = 0,
		y = 0,
	}

	self.textOffset = {
		x = 0,
		y = 0,
	}

	self.backgroundColor = nil
	self:calculateTextCenter()
end

-- Sets the text offset of the button
-- @tparam ?number x The x offset of the button
-- @tparam ?number y The y offset of the button
function Button:setTextOffset (x, y)
	self.textOffset.x = x or self.textOffset.x
	self.textOffset.y = y or self.textOffset.y
end

-- Sets the background color of the button
-- @tparam Color the color to set
function Button:setBackgroundColor (color)
	self.backgroundColor = color
end

-- Calculates where to start drawing text in order for it to be centered
function Button:calculateTextCenter ()
	local width, height = self.text:getDimensions()

	self.textPosition.x = (self.position.x + (self.size.width / 2) - (width / 2) + self.textOffset.x)
	self.textPosition.y = (self.position.y + (self.size.height / 2) - (height / 2) + self.textOffset.y)
end


-- Sets the buttons position
-- @tparam number x The x position
-- @tparam number y The y position
function Button:setPosition (x, y)
	GUIElement.setPosition(self, x, y)
	self:calculateTextCenter()
end

-- Sets the buttons font
-- @tparam Font font The LÖVE font to use for the button
-- @tparam number size The font size to use
function Button:setFont (font, size)
	self.text:setFont(font, size)
	self:calculateTextCenter()
end

-- Sets the button text
-- @tparam string text The new text of the button
function Button:setText (text)
	self.text:set(text)
	self:calculateTextCenter()
end


function Button:afterScaled ()
	self:calculateTextCenter()
end

function Button:draw ()
	GUIElement.draw(self)
	if self.text ~= nil then
		if self.backgroundColor ~= nil then
			love.graphics.setColor(self.backgroundColor:to01())
			love.graphics.rectangle( 'fill', self.position.x, self.position.y, self.size.width, self.size.height )

			love.graphics.setColor(1, 1, 1, 1)
		end

		love.graphics.draw(self.text, self.textPosition.x, self.textPosition.y)
	end
end

return Button
