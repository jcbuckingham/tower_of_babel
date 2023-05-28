if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

_G.anim8 = require "libraries/anim8"

require "objects/game"
require "objects/inventory"


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

		if game.timeOfDay == "night" then
			game.map:drawLayer(game.map.layers["Night Filter"])
			game.map:drawLayer(game.map.layers["Night Filter 2"])
			game.map:drawLayer(game.map.layers["Lights On"])
		end
		-- game.windfieldWorld:draw()
	game.camera:detach()

	if game.showInventory then
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

function love.keypressed(key, scancode, isrepeat)
	if key == "n" and game.timeOfDay == "day" then
	   game.timeOfDay = "night"
	elseif key == "n" then
		game.timeOfDay = "day"
	end

	if key == "i" and inventory.showInventory == false then
		inventory.showInventory = true
	elseif key == "i" then
		inventory.showInventory = false
	end

	if key == "a" and not inventory.items[0] then
		inventory.addNewItem(0, 1)
	end

	if key == "o" and inventory.items[0] and inventory.items[0].count == 10 then
		inventory.items[0].count = 0
	elseif key == "o" then
		if inventory.items[0] then
			inventory.items[0].count = inventory.items[0].count + 1
		else
			table.insert(inventory.items, Item:new(1,1))
		end
	end
 end
