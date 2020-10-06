local cwd = string.sub(..., 1, string.len(...) - string.len('components.dropdownButton'))

local class = require(cwd .. '.lib.middleclass')

local ImageButton = require(cwd .. '.components.imageButton')

local Button = require(cwd .. '.components.button')
local ScrollPanel = require(cwd .. '.components.scrollPanel')

local defaultColors = require(cwd .. 'data.defaultColors')

local DropdownButton = class('DropdownButton', ImageButton)

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
		end

		function optionElement:onExit ()
			self:setBackgroundColor(nil)
		end
		
		local elHeight = optionElement:getHeight()

		self.optionListData.height = self.optionListData.height + elHeight

		self.optionPanel:addChild(optionElement)
	end
end

function DropdownButton:updateOptionPositions ()
	for i, v in ipairs(self.optionPanel.children) do
		local yPos = self.bottomRight.y + (v:getHeight() * (i - 1))

		v:setPosition(self.position.x, yPos)
	end

	self.optionPanel:setPosition(self.position.x, self.bottomRight.y)
end

function DropdownButton:initialize (images, text, position, size, font, options, listHeight)
	ImageButton.initialize(self, images, text, position, size, font)
	self.options = options

	self.isOpened = false

	self.optionListData = {
		height = 0,
		selectedOption = nil,
	}

	self.listHeight = listHeight or 0

	self.optionPanel = ScrollPanel(
		{x = self.position.x, y = self.bottomRight.y},
		{ width = self.size.width, height = 500},
		defaultColors.blueHorizon,
		{ width = self.size.width, height = listHeight}
	)

	self:createOptions()
	self:updateOptionPositions()

	self.optionPanel:setCanvasHeight(self.optionListData.height)

	self:addChild(self.optionPanel)
end

function DropdownButton:drawList ()
	self.optionPanel:updateCanvas()
	self.optionPanel:draw()
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
