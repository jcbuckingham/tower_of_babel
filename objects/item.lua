local class = require 'libraries/middleclass'

Item = class('Item')
Item.static.spriteSheet = love.graphics.newImage("assets/sprites/34x34icons180709.png")
-- Temporary test data 
Item.static.data = {
    [0] = {
        row = 0,
        column = 0,
        name = "blackberry"
    },
    [1] = {
        row = 0,
        column = 1,
        name = "tomato"
    }
}
Item.static.hw = 32

-- Init inventory items
function Item:initialize(itemNumber, count, xOffset, yOffset)
    local quadX = (Item.data[itemNumber].row * Item.hw)
    local quadY = (Item.data[itemNumber].row * Item.hw)
    local quad = love.graphics.newQuad(quadX, quadY, Item.hw, Item.hw, Item.spriteSheet:getWidth(), Item.spriteSheet:getHeight())
    self.name = Item.data[itemNumber].name
    self.itemNumber = itemNumber
    self.count = count
    self.quad = quad
    self.x = Inventory.inventoryOX + xOffset
    self.y = Inventory.inventoryOY + yOffset
 end
