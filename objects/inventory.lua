local class = require 'libraries/middleclass'
local sti = require "libraries/sti"

require "objects/item"

Inventory = class("Inventory")

Inventory.static.inventoryOX = 104
Inventory.static.inventoryOY = 62

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

function Inventory:addNewItem(itemId, count)
    local item = Item:new(itemId, count)
    table.insert(self.items, item)
end

function Inventory:drawInventory()
    for i, item in self.items do
        lg:draw(self.spriteSheet, item.quad, item.x, item.y)
    end
end
