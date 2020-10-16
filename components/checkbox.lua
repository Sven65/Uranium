--- A Checkbox
-- @module Checkbox

local cwd = string.sub(..., 1, string.len(...) - string.len('.components.checkbox'))

local class = require(cwd .. '.lib.middleclass')

local Button = require(cwd .. '.components.button')

local Checkbox = class('Checkbox', Button)

local iconFont = love.graphics.newFont(cwd:gsub('%.', '/') .. '/assets/fonts/icons.ttf', 24)

--- Creates a new Checkbox
-- @tparam table colors The colors to use for the different checkbox states
-- @field Color colors.default The color to use when the checkbox is in the default state
-- @field Color colors.hover The color to use when the checkbox is hovered
-- @field Color colors.click The color to use when the checkbox is clicked
-- @tparam Position position The position of the checkbox
-- @tparam Size size The size of the checkbox
-- @treturn Checkbox
function Checkbox:initialize (colors, position, size)
	self.colors = colors

	self.checked = false
	self.disabled = false

	Button.initialize(self, "", position, size, iconFont)
end

--- Sets if the checkbox is checked
-- @tparam boolean isChecked If the checkbox should be checked
function Checkbox:setChecked (isChecked)
	self.checked = isChecked

	self:setText(self.checked and "" or "")
end

function Checkbox:onLeftClick ()
	if self.disabled then return end
	self.checked = not self.checked

	self:setText(self.checked and "" or "")

	if self.checked and type(self.onCheck) == 'function' then
		self.onCheck(self)
	end

	if not self.checked and type(self.onUnCheck) == 'function' then
		self.onUnCheck(self)
	end
end


-- Draws the Checkbox
function Checkbox:draw ()
	Button.draw(self)

	love.graphics.setColor(self.colors[self.currentState]:to01())


	love.graphics.rectangle('fill', self.position.x, self.position.y, self.size.width, self.size.height)

	love.graphics.setColor(1,1,1,1)

	if self.text ~= nil then
		love.graphics.draw(self.text, self.textPosition.x, self.textPosition.y)
	end
end



return Checkbox
