local cwd = string.sub(..., 1, string.len(...) - string.len('components.label'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Label = class('Label', GUIElement)


function Label:initialize (font, text, position)
	self.text = love.graphics.newText(font, text)

	local width, height = self.text:getDimensions()

	GUIElement.initialize(self, { width = width, height = height }, position)

end

function Label:draw ()
	GUIElement.draw(self)

	love.graphics.draw(self.text, self.position.x, self.position.y)
end

return Label
