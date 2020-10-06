local cwd = string.sub(..., 1, string.len(...) - string.len('.components.imageButton'))

local class = require(cwd .. '.lib.middleclass')

local Button = require(cwd .. '.components.button')

local ImageButton = class('ImageButton', Button)

function ImageButton:initialize (images, text, position, size, font)
	if size == nil then
		local width, height = images.default:getDimensions()

		size = { width = width, height = height }
	end

	self.images = images

	Button.initialize(self, text, position, size, font)
end


function ImageButton:draw ()
	Button.draw(self)

	love.graphics.draw(self.images[self.currentState], self.position.x, self.position.y)

	if self.text ~= nil then
		love.graphics.draw(self.text, self.textPosition.x, self.textPosition.y)
	end
end



return ImageButton
