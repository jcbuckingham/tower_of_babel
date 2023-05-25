local class = require 'libraries/middleclass'
local sti = require "libraries/sti"
local bump = require 'libraries/bump'
require "objects/character"
require "objects/block"

Game = class('Game')

function Game:initialize()
    -- local world = love.physics.newWorld(0, 200, True)
    -- world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    local world = bump.newWorld(32*Character.scale)
    local mc = Game:initCharacter(20, 20, 2, 11)
    local level1NPCs = {
        george = Game:initCharacter(80, 350, 0, 7),
        frederico = Game:initCharacter(_G.w-160, 350, 0, 8)
    }
    local level1Blocks = {
        marketPlant = Block:new(535, 160, 96, 96),
        fountain = Block:new(570, 0, 40, 26)
    }
    world:add(mc, mc.x, mc.y, mc.width, mc.height)
    world:add(
        level1NPCs.george, 
        level1NPCs.george.x, 
        level1NPCs.george.y-Character.offset, 
        level1NPCs.george.width, 
        level1NPCs.george.height*Character.scale
    )
    world:add(
        level1NPCs.frederico, 
        level1NPCs.frederico.x, 
        level1NPCs.frederico.y-Character.offset, 
        level1NPCs.frederico.width, 
        level1NPCs.frederico.height*Character.scale
    )
    world:add(
        level1Blocks.marketPlant,
        level1Blocks.marketPlant.x, 
        level1Blocks.marketPlant.y,
        level1Blocks.marketPlant.width,
        level1Blocks.marketPlant.height
    )
    world:add(
        level1Blocks.fountain,
        level1Blocks.fountain.x, 
        level1Blocks.fountain.y,
        level1Blocks.fountain.width,
        level1Blocks.fountain.height
    )

    level1NPCs.frederico:setCurrentAnimation("walkLeft")

    self.mc = mc
    self.level1NPCs = level1NPCs
    self.level1Blocks = level1Blocks
    self.map = sti("assets/maps/market_1.lua")
    self.world = world
end

function Game:initCharacter(x, y, speed, characterNum)
    return Character:new(x, y, speed, characterNum)
end

function Game:drawCharacters()
    local george = self.level1NPCs.george
    local frederico = self.level1NPCs.frederico
	george.currentAnimation:draw(george:getSpriteSheet(), george.x, george.y, nil, Character.scale)
	frederico.currentAnimation:draw(frederico:getSpriteSheet(), frederico.x, frederico.y, nil, Character.scale)
	self.mc.currentAnimation:draw(game.mc:getSpriteSheet(), game.mc.x, game.mc.y, nil, Character.scale)
end

function Game:updateCharacters(dt)
    game.mc:move()
	game.mc.currentAnimation:update(dt)
	game.level1NPCs.george.currentAnimation:update(dt)
	game.level1NPCs.frederico.currentAnimation:update(dt)
end
