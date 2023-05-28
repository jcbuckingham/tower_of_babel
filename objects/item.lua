local class = require 'libraries/middleclass'

Item = class('Item')
local spriteSheet = love.graphics.newImage("assets/sprites/34x34icons180709.png")

local data = {
    [0] = {
        row = 1,
        column = 1,
        name = "blackberry"
    },
    [1] = {
        row = 1,
        column = 2,
        name = "tomato"
    }
}
local hw = 32

function Item:initialize(itemNumber, count)
    local quad = lg.newQuad(
        hw*data[itemNumber].row, 
        hw*data[itemNumber].column, 
        hw, 
        hw, 
        spriteSheet:getWidth(), 
        spriteSheet:getHeight()
    )
    self.name = data[itemNumber].name
    self.itemNumber = itemNumber
    self.count = count
    self.image = quad
    self.x = inventory.inventoryOX + 100
    self.y = inventory.inventoryOY + 100
 end
