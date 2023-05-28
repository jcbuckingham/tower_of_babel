local class = require 'libraries/middleclass'
local sti = require "libraries/sti"
local windfield = require "libraries/windfield"
local camera = require "libraries/camera"
require "objects/character"
require "objects/block"

Game = class('Game')

function Game:initialize()
    local camera = camera()
    local windfieldWorld = windfield.newWorld(0, 0)
    local map = sti("assets/maps/market_2.lua")
    local mapW = map.width * map.tilewidth
	local mapH = map.height * map.tileheight
    local inventoryMap = sti("assets/maps/inventory.lua", nil, 104, 62)
    local inventoryMapW = inventoryMap.width * inventoryMap.tilewidth
	local inventoryMapH = inventoryMap.height * inventoryMap.tileheight
    local mc = Game:initCharacter(1200, mapH*2/3, 30, 50, 100000, "Senlin")

    local walls  = {}
    local wall = nil
	if map.layers["Walls"] then
		for i, obj in pairs(map.layers["Walls"].objects) do
			wall = windfieldWorld:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
			wall:setType("static")
			table.insert(walls, wall)
		end
	end

    local npcs = {}
    local npcData = nil
    local npc = nil
    local npcCollider = nil
    if map.layers["NPCs"] then
		for i, obj in pairs(map.layers["NPCs"].objects) do

            npcData = Character.npcData[obj.id]
            npc = Game:initCharacter(obj.x, obj.y, 30, 50, npcData.animationSetNum, npcData.name)
            npc.currentAnimationDirection = npcData.animationDirection
            npc.currentAnimation = npc:getStandAnimation()
            npc.currentAnimationType = "stand"
            npcCollider = windfieldWorld:newRectangleCollider(obj.x - npc.width/2, obj.y - npc.height*3/4, npc.width, npc.height)
            npcCollider:setType("static")
            table.insert(npcs, npc)
		end
	end

    self.mc = mc
    self.npcs = npcs
    self.walls = walls
    self.map = map
    self.mapH = mapH
    self.mapW = mapW
    self.inventoryMap = inventoryMap
    self.inventoryMapH = inventoryMapH
    self.inventoryMapW = inventoryMapW
    self.windfieldWorld = windfieldWorld
    self.camera = camera
    self.timeOfDay = "day"
    self.showInventory = false

end

function Game:initCharacter(x, y, width, height, characterNum, name)
    return Character:new(x, y, width, height, characterNum, name)
end

function Game:drawCharacters()
    for i, npc in pairs(self.npcs) do
        npc.currentAnimation:draw(
            npc:getSpriteSheet(), 
            npc.x - npc.width*0.75, 
            npc.y - npc.height, 
            nil, 
            1
        )
        -- love.graphics.push("all")    
		-- love.graphics.setColor(0, 0, 0)
        -- label = "name:\n"..npc.name.."\ndir:\n"..npc.currentAnimationDirection.."\ntype:\n"..npc.currentAnimationType.."\nset:\n"..tostring(npc.animationSetNumber)
        -- love.graphics.print(label, npc.x, npc.y)
        -- love.graphics.pop()
    end
	self.mc.currentAnimation:draw(
        self.mc:getSpriteSheet(), 
        self.mc.x, 
        self.mc.y, 
        nil, 
        1.2, 
        nil, 
        self.mc.width/2, 
        self.mc.height/1.8
    )
end

function Game:updateCharacters(dt)
    for i, npc in pairs(self.npcs) do
        npc.currentAnimation:update(dt)
    end
    self.mc:move()
	self.mc.currentAnimation:update(dt)
end

function Game:updateCamera()
    self.camera:lookAt(self.mc.x, self.mc.y)

	if self.camera.x < w/2 then
		self.camera.x = w/2
	end
	if self.camera.y < h/2 then
		self.camera.y = h/2
	end

	if self.camera.x > (self.mapW - w/2) then
		self.camera.x = (self.mapW - w/2)
	end
	if self.camera.y > (self.mapH - h/2) then
		self.camera.y = (self.mapH - h/2)
	end
end
