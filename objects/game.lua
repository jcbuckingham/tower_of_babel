local class = require 'libraries/middleclass'
local sti = require "libraries/sti"
require "objects/character"

Game = class('Game')

function Game:initialize()
    local world = love.physics.newWorld(0, 200, True)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    local mc = Game:initCharacter(20, 20, 2, 11)
    local level1NPCs = {
        george = Game:initCharacter(80, 350, 0, 7),
        frederico = Game:initCharacter(_G.w - 160, 350, 0, 8)
    }
    level1NPCs.frederico:setCurrentAnimation("walkLeft")
    self.mc = mc
    self.level1NPCs = level1NPCs
    self.map = sti("assets/maps/market_1.lua")
    self.world = world
end

function Game:initCharacter(x, y, speed, characterNum)
    return Character:new(x, y, speed, characterNum)
end

function Game:drawCharacters()
	self.level1NPCs.george.currentAnimation:draw(game.level1NPCs.george:getSpriteSheet(), game.level1NPCs.george.x, game.level1NPCs.george.y, nil, 1.6)
	self.level1NPCs.frederico.currentAnimation:draw(game.level1NPCs.frederico:getSpriteSheet(), game.level1NPCs.frederico.x, game.level1NPCs.frederico.y, nil, 1.6)

	self.mc.currentAnimation:draw(game.mc:getSpriteSheet(), game.mc.x, game.mc.y, nil, 1.6)
end

function Game:updateCharacters(dt)
    game.mc:move()
	game.mc.currentAnimation:update(dt)
	game.level1NPCs.george.currentAnimation:update(dt)
	game.level1NPCs.frederico.currentAnimation:update(dt)
end