local cwd = string.sub(..., 1, string.len(...) - string.len('.components.flatButton'))

local buttonImage = love.graphics.newImage(cwd:gsub('%.', '/') .. '/assets/FlatButton.png')

local class = require(cwd .. '.lib.middleclass')

local Button = require(cwd .. '.components.button')

local FlatButton = class('FlatButton', Button)

local defaultColors = require(cwd .. '.data.defaultColors')

function FlatButton:initialize (text, colors, position, size, font)
	self.colors = colors

	if size == nil then
		local width, height = buttonImage:getDimensions()

		size = { width = width, height = height }
	end

	Button.initialize(self, text, position, size, font)
end


function FlatButton:draw ()
	Button.draw(self)

	love.graphics.setColor(self.colors[self.currentState]:to01())
	love.graphics.draw(buttonImage, self.position.x, self.position.y)
	love.graphics.setColor(1,1,1,1)

	if self.text ~= nil then
		love.graphics.draw(self.text, self.textPosition.x, self.textPosition.y)
	end
end



return FlatButton
