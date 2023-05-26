local class = require 'libraries/middleclass'
local sti = require "libraries/sti"
local windfield = require "libraries/windfield"
local camera = require "libraries/camera"
require "objects/character"
require "objects/block"

Game = class('Game')

function Game:initialize()
    local windfieldWorld = windfield.newWorld(0, 0)
    
    local npcs = {
        george = Game:initCharacter(80, 350, 0, 7),
        frederico = Game:initCharacter(_G.w-160, 350, 0, 8)
    }
    npcs.frederico:setCurrentAnimation("standLeft")

    local map = sti("assets/maps/market_2.lua")
    local walls  = {}
	if map.layers["Walls"] then
		for i, obj in pairs(map.layers["Walls"].objects) do
			local wall = windfieldWorld:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
			wall:setType("static")
			table.insert(walls, wall)
		end
	end
    local camera = camera()
    local mapW = map.width * map.tilewidth
	local mapH = map.height * map.tileheight
    local mc = Game:initCharacter(100, mapH*2/3, 230, 1000)

    self.mc = mc
    self.npcs = npcs
    self.walls = walls
    self.map = map
    self.mapH = mapH
    self.mapW = mapW
    self.windfieldWorld = windfieldWorld
    self.camera = camera
end

function Game:initCharacter(x, y, speed, characterNum)
    return Character:new(x, y, speed, characterNum)
end

function Game:drawCharacters()
    local george = self.npcs.george
    local frederico = self.npcs.frederico
	george.currentAnimation:draw(george:getSpriteSheet(), george.x, george.y, nil, Character.scale)
	frederico.currentAnimation:draw(frederico:getSpriteSheet(), frederico.x, frederico.y, nil, Character.scale)
	self.mc.currentAnimation:draw(game.mc:getSpriteSheet(), game.mc.x, game.mc.y, nil, Character.scale, nil, game.mc.width/2, game.mc.height/1.8)
end

function Game:updateCharacters(dt)
    game.mc:move()
	game.mc.currentAnimation:update(dt)
	game.npcs.george.currentAnimation:update(dt)
	game.npcs.frederico.currentAnimation:update(dt)
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
