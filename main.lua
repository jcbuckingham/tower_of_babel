if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require "objects/game"
_G.anim8 = require "libraries/anim8"


function love.load()
	--[[ Globals --]]
	_G.lg = love.graphics
	lg.setDefaultFilter("nearest", "nearest")
	-- _G.gameMap = sti("assets/maps/market_1.lua")
	_G.w = lg.getWidth()
	_G.h = lg.getHeight()
	_G.text = ""

	_G.game = Game:new()
end

function love.update(dt)
	game.world:update(dt)
	game:updateCharacters(dt)

    if string.len(text) > 768 then
    	text = ""
    end
end

function love.draw()
	game.map:draw()
	game:drawCharacters()

    -- love.graphics.print(text, 10, 10)
end
