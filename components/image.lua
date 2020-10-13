--- An image wrapper component
-- Used for positioning images with Uranium
-- @module Image


local cwd = string.sub(..., 1, string.len(...) - string.len('components.image'))

local class = require(cwd .. '.lib.middleclass')

local GUIElement = require(cwd .. '.components.guiElement')

local Image = class('Image', GUIElement)

--- Creates a new Image
-- @tparam Position position The position of the Image
-- @tparam ?Size size The size of the image, defaults to the size of the loaded image
-- @tparam LoveImage image The image to draw
-- @treturn Image
function Image:initialize (position, size, image)
	self.image = image

	if size == nil then
		local imageWidth, imageHeight = self.image:getDimensions()
		size = {
			width = imageWidth,
			height = imageHeight,
		}
	end

	GUIElement.initialize(self, position, size)
end

--- Sets the image to be drawn
-- @tparam LoveImage image The new image to be set
function Image:setImage(image)
	self.image = image
end

-- Draws the Image
function Image:draw ()
	GUIElement.draw(self)

	if self.image ~= nil then
		love.graphics.push()
		love.graphics.translate(self.position.x, self.position.y)

		love.graphics.draw(self.image, 0, 0)

		love.graphics.pop()
	end
end


return Image