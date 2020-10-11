local cwd = string.sub(..., 1, string.len(...) - string.len('components.dropdownButton'))

local class = require(cwd .. '.lib.middleclass')

local FlatButton = require(cwd .. '.components.flatButton')

local Button = require(cwd .. '.components.button')
local ScrollPanel = require(cwd .. '.components.scrollPanel')

local defaultColors = require(cwd .. 'data.defaultColors')

local DropdownButton = class('DropdownButton', FlatButton)

local inspect = require 'lib.inspect'

function DropdownButton:createOptions ()
	local font = self.font or love.graphics.getFont()

	for i, v in ipairs(self.options) do
		local optionElement = Button(v, {x = 0, y = 0}, nil, font)

		optionElement.align = 'left'
		--optionElement.scale = false

		function optionElement.onLeftClick (this)
			if not self.isOpened then return end
			self.isOpened = false

			self.optionListData.selectedOption = i

			self:setText(v)

			if type (self.onSelect) == 'function' then
				self.onSelect(self, v)
			end
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
end

function DropdownButton:updateOptionPositions ()
	for i, v in ipairs(self.optionPanel.children) do
		local yPos = (v:getHeight() * (i - 1))

		v:setPosition(0, yPos)
		v:setUnscaledPosition(0, yPos)
	end

	self.optionPanel:setPosition(self.position.x, self.bottomRight.y)
end


function DropdownButton:setScale (wScale, hScale)
	FlatButton.setScale(self, wScale, hScale, false)
end

function DropdownButton:initialize (text, colors, position, size, font, options, listHeight)
	FlatButton.initialize(self, text, colors, position, size, font)

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
	self.optionPanel:setPosition(0, self.bottomRight.y)

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

function DropdownButton:afterScaled ()
	self.optionPanel:setSize(self.size.width, self.optionPanel.size.height)

	self.optionPanel:setClipSize(self.size.width, self.listHeight * self.scale.h)
	self.optionPanel:setPosition(nil, self.bottomRight.y)
end

function DropdownButton:draw ()
	FlatButton.draw(self)

	if self.isOpened then
		self:drawList()
	end
end

return DropdownButton
