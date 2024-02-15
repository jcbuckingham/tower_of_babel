local class = require 'libraries/middleclass'
local sti = require "libraries/sti"

require "objects/item"

Inventory = class("Inventory")

Inventory.static.inventoryOX = 104
Inventory.static.inventoryOY = 62

-- Init inventory
function Inventory:initialize()
    local inventoryMap = sti("assets/maps/inventory.lua", nil, 104, 62)
    local inventoryMapW = inventoryMap.width * inventoryMap.tilewidth
	local inventoryMapH = inventoryMap.height * inventoryMap.tileheight

    self.items = {}
    self.inventoryMap = inventoryMap
    self.inventoryMapH = inventoryMapH
    self.inventoryMapW = inventoryMapW
    self.showInventory = false
end

-- Adds a new item to the inventory in the next available slot
function Inventory:addNewItem(itemId, count)
    local itemsLen = self:getItemCount()
    local xOffset, yOffset = 10, 10
    if itemsLen > 0 then
        xOffset = (itemsLen % 12) * 48 + 10
        yOffset = (math.floor(itemsLen / 12)) * 48 + 10
    end

    local item = Item:new(itemId, count, xOffset, yOffset)
    table.insert(self.items, item)
end

-- Draws sprites onto inventory window
function Inventory:drawInventory()
    for i, item in ipairs(self.items) do
        love.graphics.draw(
            Item.spriteSheet, 
            item.quad, 
            item.x, 
            item.y
        )
    end
end

-- Returns inventory item count
function Inventory:getItemCount()
    return _G:tablelength(self.items)
end

-- function Inventory:updateInventory(dt)
-- end
