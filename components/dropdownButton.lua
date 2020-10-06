local cwd = string.sub(..., 1, string.len(...) - string.len('components.dropdownButton'))

local class = require(cwd .. '.lib.middleclass')

local ImageButton = require(cwd .. '.components.imageButton')

local Button = require(cwd .. '.components.button')
local ScrollPanel = require(cwd .. '.components.scrollPanel')

local defaultColors = require(cwd .. 'data.defaultColors')

local DropdownButton = class('DropdownButton', ImageButton)

local inspect = require 'lib.inspect'

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

		function optionElement:onEnter ()
			self:setBackgroundColor(defaultColors.red)
		end

		function optionElement:onExit ()
			self:setBackgroundColor(nil)
		end
		
		local elHeight = optionElement:getHeight()

		self.optionListData.height = self.optionListData.height + elHeight

		local yPos = self.optionPanel.position.y + (elHeight * (i - 1))

		optionElement:setPosition(self.optionPanel.position.x, yPos)

		self.optionPanel:addChild(optionElement)

		print("optionElement", inspect(optionElement.position))
	end

	--self.optionPanel:setPosition(self.position.x, self.bottomRight.y)
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

	print("option count", #options)

	self.isOpened = false

	self.optionListData = {
		height = 0,
		selectedOption = nil,
	}

	self.listHeight = listHeight or 0

	self.optionPanel = ScrollPanel(
		{x = self.position.x, y = self.bottomRight.y},
		{ width = self.size.width, height = self.size.height},
		defaultColors.blueHorizon,
		{ width = self.size.width, height = listHeight}
	)

	print("bottom", inspect(self.bottomRight))

	self:createOptions()
	self:updateOptionPositions()

	self.optionPanel:setSize(self.size.width, self.optionListData.height)
	self.optionPanel:setPosition(self.position.x, self.bottomRight.y)

	self:addChild(self.optionPanel)


end

function DropdownButton:drawList ()
	self.optionPanel:updateCanvas()

	self.optionPanel:draw()
end

function DropdownButton:onLeftClick ()
	self.isOpened = not self.isOpened
	

	if self.isOpened then
		--self.optionPanel:setPosition(self.position.x, self.bottomRight.y)

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

	love.graphics.push()
	love.graphics.translate(self.position.x, self.position.y)

	for i, v in ipairs(self.children) do
		v:update(dt)
	end

	love.graphics.pop()
end

return DropdownButton
