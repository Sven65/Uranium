local cwd = string.sub(..., 1, string.len(...) - string.len('components.button'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Button = class('Button', GUIElement)

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

function Button:setTextOffset (x, y)
	self.textOffset = {
		x = x or self.textOffset.x,
		y = y or self.textOffset.y,
	}
end

function Button:setBackgroundColor (color)
	self.backgroundColor = color
end

function Button:calculateTextCenter ()
	local width, height = self.text:getDimensions()

	self.textPosition.x = (self.position.x + (self.size.width / 2) - (width / 2) + self.textOffset.x)
	self.textPosition.y = (self.position.y + (self.size.height / 2) - (height / 2) + self.textOffset.y)

end

function Button:setPosition (x, y)
	GUIElement.setPosition(self, x, y)
	self:calculateTextCenter()
end

function Button:setFont (font, size)
	self.text:setFont(font, size)
	self:calculateTextCenter()
end

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
