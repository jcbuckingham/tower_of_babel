if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require "objects/game"
_G.anim8 = require "libraries/anim8"


function love.load()
	--[[ Globals --]]
	_G.lg = love.graphics
	lg.setDefaultFilter("nearest", "nearest")
	_G.w = lg.getWidth()
	_G.h = lg.getHeight()
	_G.text = ""

	_G.game = Game:new()
end

function love.update(dt)
	game:updateCharacters(dt)
	game.windfieldWorld:update(dt)
	game:updateCamera()

    if string.len(text) > 768 then
    	text = ""
    end
end

function love.draw()
	game.camera:attach()
		game.map:drawLayer(game.map.layers["Background"])
		game.map:drawLayer(game.map.layers["Ground Tiles"])
		game.map:drawLayer(game.map.layers["Under MC 1"])
		game.map:drawLayer(game.map.layers["Under MC 2"])
		game:drawCharacters()
		game.map:drawLayer(game.map.layers["Over MC 1"])
		game.map:drawLayer(game.map.layers["Over MC 2"])
		-- game.windfieldWorld:draw()
	game.camera:detach()

		-- love.graphics.push("all")    
		-- love.graphics.setColor(0, 0.2, 0.5)
		-- love.graphics.print(text, 10, 10)
		-- love.graphics.pop()
end
