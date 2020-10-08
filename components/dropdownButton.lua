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

		optionElement.align = 'left'

		function optionElement.onLeftClick (this)
			if not self.isOpened then return end
			self.isOpened = false

			self.optionListData.selectedOption = i

			self:setText(v)
		end

		function optionElement.onEnter (this)
			if not self.isOpened then return end

			this:setBackgroundColor(defaultColors.red)
		end

		function optionElement.onExit (this)
			if not self.isOpened then return end

			this:setBackgroundColor(nil)
		end
		
		local elHeight = optionElement:getHeight()

		self.optionListData.height = self.optionListData.height + elHeight
		self.optionPanel:addChild(optionElement)
	end

	--self.optionPanel:setPosition(self.position.x, self.bottomRight.y)
end

function DropdownButton:updateOptionPositions ()
	for i, v in ipairs(self.optionPanel.children) do
		local yPos = (v:getHeight() * (i - 1))

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
		{x = 0, y = self.size.height},
		{ width = self.size.width, height = self.size.height},
		defaultColors.blueHorizon,
		{ width = self.size.width, height = listHeight}
	)

	self:createOptions()
	self:updateOptionPositions()

	self.optionPanel:setSize(self.size.width, self.optionListData.height)
	self.optionPanel:setPosition(self.position.x, self.bottomRight.y)

	self:addChild(self.optionPanel)
end

function DropdownButton:drawList ()
	love.graphics.push()

	love.graphics.translate(self.position.x, self.position.y)

	self.optionPanel:draw()

	love.graphics.pop()
end

function DropdownButton:onLeftClick ()
	self.isOpened = not self.isOpened
end

function DropdownButton:draw ()
	ImageButton.draw(self)

	if self.isOpened then
		self:drawList()
	end
end

return DropdownButton
