if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

_G.anim8 = require "libraries/anim8"

require "objects/game"
require "objects/inventory"

function _G:tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function love.load()
	--[[ Globals --]]
	_G.lg = love.graphics
	lg.setDefaultFilter("nearest", "nearest")
	_G.w = lg.getWidth()
	_G.h = lg.getHeight()
	_G.text = ""

	_G.inventory = Inventory:new()
	_G.game = Game:new()
end

-- Actions to take on each frame update
function love.update(dt)
	game:updateCharacters(dt)
	game.windfieldWorld:update(dt)
	game:updateCamera()
	-- inventory:updateInventory()

    if string.len(text) > 768 then
    	text = ""
    end
end

-- Actions to take when drawing each frame
function love.draw()
	game.camera:attach()
		-- Draw map layers in order
		game.map:drawLayer(game.map.layers["Background"])
		game.map:drawLayer(game.map.layers["Ground Tiles"])
		game.map:drawLayer(game.map.layers["Under MC 1"])
		game.map:drawLayer(game.map.layers["Under MC 2"])
		game:drawCharacters()
		game.map:drawLayer(game.map.layers["Over MC 1"])
		game.map:drawLayer(game.map.layers["Over MC 2"])

		-- Draw day/night
		if game.timeOfDay == "night" then
			game.map:drawLayer(game.map.layers["Night Filter"])
			game.map:drawLayer(game.map.layers["Night Filter 2"])
			game.map:drawLayer(game.map.layers["Lights On"])
		end
	game.camera:detach()

	-- Draws inventory over map if showInventory is true
	if inventory.showInventory then
		game.map:drawLayer(game.map.layers["Obscure"])
		inventory.inventoryMap:drawLayer(inventory.inventoryMap.layers["Background"])
		inventory.inventoryMap:drawLayer(inventory.inventoryMap.layers["Tiles 1"])
		inventory.inventoryMap:drawLayer(inventory.inventoryMap.layers["Tiles 2"])
		inventory:drawInventory()
	end

		-- love.graphics.push("all")    
		-- love.graphics.setColor(0, 0.2, 0.5)
		-- love.graphics.print(text, 10, 10)
		-- love.graphics.pop()
end

-- Detect macros
function love.keypressed(key, scancode, isrepeat)
	-- Toggle day/night
	if key == "n" and game.timeOfDay == "day" then
	   game.timeOfDay = "night"
	elseif key == "n" then
		game.timeOfDay = "day"
	end

	-- Toggle inventory
	if key == "i" and inventory.showInventory == false then
		inventory.showInventory = true
	elseif key == "i" then
		inventory.showInventory = false
	end

	-- TEMPORARY for testing only: add test items to inventory
	if key == "u" and not inventory.items[0] then
		inventory:addNewItem(0, 1)
	end
 end
