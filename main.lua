if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require "objects/character"
sti = require "libraries/sti"
anim8 = require "libraries/anim8"


function love.load()
	--[[ Globals --]]
	_G.lg = love.graphics
	lg.setDefaultFilter("nearest", "nearest")
	_G.world = love.physics.newWorld(0, 200, True)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	_G.gameMap = sti("assets/maps/market_1.lua")
	_G.w = lg.getWidth()
	_G.h = lg.getHeight()

	_G.character = Character:new(10, 10, 2, 11)
	_G.npc1 = Character:new(80, 350, 1.5, 7)
	_G.npc2 = Character:new(w-160, 350, 1.5, 8)
	npc2:setCurrentAnimation("walkLeft")

	_G.text = ""
end

function love.update(dt)
	world:update(dt)
	character:move()

	character.currentAnimation:update(dt)
	npc1.currentAnimation:update(dt)
	npc2.currentAnimation:update(dt)

    if string.len(text) > 768 then
    	text = ""
    end
end

function love.draw()
	gameMap:draw()

	npc1.currentAnimation:draw(npc1:getSpriteSheet(), npc1.x, npc1.y, nil, 1.6)
	npc2.currentAnimation:draw(npc2:getSpriteSheet(), npc2.x, npc2.y, nil, 1.6)

	character.currentAnimation:draw(character:getSpriteSheet(), character.x, character.y, nil, 1.6)

    love.graphics.print(text, 10, 10)
end
