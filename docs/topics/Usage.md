# Using Uranium

Using Uranium is simple, and doesn't take any effort.

In order to do so, require the component(s) you'd like to use, and then do so, a simple "Hello World" example can be found below.

```lua
local Label = require 'Uranium.components.label'

local font = love.graphics.getFont()

local myLabel = Label(
	robotoMono,
	{ defaultColors.white:to01(), 'Hello World!' },
	{ x = 0, y = 0}
)
```
![](https://i.imgur.com/7USrvcP.png)


## Components

In Uranium, the components are classed as parents and children, and are easy to work with, following the core design of Uranium.

- All components can have children
- The position of a child is relative to its parent.

## Adding a child component

Adding a child to a parent is straight forward:

```lua
local Label = require 'Uranium.components.label'
local Panel = require 'Uranium.components.panel'
local defaultColors = require 'Uranium.data.defaultColors'

local font = love.graphics.getFont()

-- Create a new panel
local container = Panel(
	{ x = 0, y = 0},
	{ width = 128, height = 64 }, -- Set the size
	defaultColors.blueGrey -- Background color
)

local myLabel = Label(
	font,
	{ defaultColors.black:to01(), 'Hello World!' },
	{ x = 0, y = 16} -- Position the label 16px from the top of the container
)

container:addChild(myLabel) -- Add the label to the container

function love.draw ()
	container:draw()
end
```

![](https://i.imgur.com/vzew7hq.png)

## Events

All components are able to execute the following event callbacks:

|    Function    | Called when                                                   |
|:--------------:|---------------------------------------------------------------|
| onEnter        | Called when the mouse enters the bounding box of the element  |
| onExit         | Called when the mouse exits the bounding box of the element   |
| onPreLeftClick | Called when the element is clicked with the left mouse button |

In order for these events to be called, you need to propagate the events to the parent components.

```lua
function love.mousemoved (x, y)
	guiElement:mousemoved(x, y)
end

function love.mousepressed (x, y, button)
	guiElement:mousemoved(x, y, button)
end

function love.mousereleased (x, y, button)
	guiElement:mousereleased(x, y, button)
end

function love.wheelmoved (x, y)
	guiElement:wheelmoved(x, y)
end
```