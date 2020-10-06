local cwd = string.sub(..., 1, string.len(...) - string.len('components.dropdownButton'))

local class = require(cwd .. '.lib.middleclass')

local ImageButton = require(cwd .. '.components.imageButton')

local Button = require(cwd .. '.components.button')

local DropdownButton = class('DropdownButton', ImageButton)

--local defaultColors = require 'game.enums.defaultColors'


function DropdownButton:createOptions ()
	local font = self.font or love.graphics.getFont()

	for i, v in ipairs(self.options) do
		local optionElement = Button(v, {x = 0, y = 0}, nil, font)

		function optionElement.onLeftClick (this)
			if not self.isOpened then return end
			self.isOpened = false

			self.optionListData.selectedOption = i

			self:setText(v)
		end

		function optionElement:onEnter ()
			self:setBackgroundColor(defaultColors.red)
			--this:setBackgroundColor(defaultColors.red:to01())
		end

		function optionElement:onExit ()
			self:setBackgroundColor(nil)
			--this:setBackgroundColor(defaultColors.red:to01())
		end
		
		local elHeight = optionElement:getHeight()

		self.optionListData.height = self.optionListData.height + elHeight

		table.insert(self.children, optionElement)
	end
end

function DropdownButton:updateOptionPositions ()
	for i, v in ipairs(self.children) do
		local yPos = self.bottomRight.y + (v:getHeight() * (i - 1))

		v:setPosition(self.position.x, yPos)
	end
end

function DropdownButton:initialize (images, text, position, size, font, options)
	ImageButton.initialize(self, images, text, position, size, font)
	self.options = options

	self.isOpened = false

	self.children = {}

	self.optionListData = {
		height = 0,
		selectedOption = nil,
	}

	self:createOptions()
	self:updateOptionPositions()
end

function DropdownButton:drawList ()
	love.graphics.setColor(defaultColors.blueHorizon:to01())
	love.graphics.rectangle( 'fill', self.position.x, self.bottomRight.y, self.size.width, self.optionListData.height )

	love.graphics.setColor(defaultColors.white:to01())

	for i, v in ipairs(self.children) do
		v:draw()
	end
end

function DropdownButton:onLeftClick ()
	self.isOpened = not self.isOpened

	if self.isOpened then
		self:updateOptionPositions()
	end
end

function DropdownButton:draw ()
	ImageButton.draw(self)

	if self.isOpened then
		self:drawList()
	end
end

function DropdownButton:update (dt)
	ImageButton.update(self, dt)

	for i, v in ipairs(self.children) do
		v:update(dt)
	end
end

return DropdownButton
