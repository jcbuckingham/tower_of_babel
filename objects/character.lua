local class = require 'libraries/middleclass'
SET_1_SPRITESHEET = "assets/sprites/villager-females.png"
SET_2_SPRITESHEET = "assets/sprites/villager-males_1.png"
SET_3_SPRITESHEET = "assets/sprites/armored-npcs.png"
SET_4_SPRITESHEET = "assets/sprites/male-leather-armor-set_1.png"
ANIMAL_SPRITESHEET_1 = "assets/sprites/animal_sprites_1.png"
MC_SPRITESHEET = "assets/sprites/senlin.png"

Character = class('Character')

Character.static.scale = 1.6
Character.static.offset = 23
Character.static.speed = 250
-- TODO: Decouple NPCs from Character
Character.static.npcData = {
   [114]={
      animationDirection = "right",
      animationSetNum = 1,
      name = "Baker"
   },
   [115]={
      animationDirection = "down",
      animationSetNum = 9,
      name = "Florist"
   },
   [117]={
      animationDirection = "right",
      animationSetNum = 10,
      name = "Market Stand 1"
   },
   [118]={
      animationDirection = "up",
      animationSetNum = 2,
      name = "Market Stand 2"
   },
   [119]={
      animationDirection = "up",
      animationSetNum = 7,
      name = "Food Cart"
   },
   [120]={
      animationDirection = "down",
      animationSetNum = 3,
      name = "Grocer"
   },
   [121]={
      animationDirection = "left",
      animationSetNum = 8,
      name = "Launderer"
   },
   [122]={
      animationDirection = "right",
      animationSetNum = 14,
      name = "Fountain Person 1"
   },
   [123]={
      animationDirection = "left",
      animationSetNum = 11,
      name = "Fountain Person 2"
   },
   [125]={
      animationDirection = "left",
      animationSetNum = 6,
      name = "Market Stand 3"
   },
   [126]={
      animationDirection = "up",
      animationSetNum = 5,
      name = "Market Stand 4"
   },
   [127]={
      animationDirection = "left",
      animationSetNum = 7,
      name = "Market Stand 5"
   },
   [128]={
      animationDirection = "down",
      animationSetNum = 13,
      name = "Peddler"
   },
   [129]={
      animationDirection = "right",
      animationSetNum = 16,
      name = "Shopper 1"
   },
   [132]={
      animationDirection = "left",
      animationSetNum = 9,
      name = "Shopper 2"
   },
   [133]={
      animationDirection = "down",
      animationSetNum = 4,
      name = "Innkeeper"
   },
   [134]={
      animationDirection = "up",
      animationSetNum = 25,
      name = "Guard 1"
   },
   [135]={
      animationDirection = "down",
      animationSetNum = 25,
      name = "Guard 2"
   },
   [139]={
      animationDirection = "down",
      animationSetNum = 15,
      name = "Grocery Cart"
   },
   [148]={
      animationDirection = "down",
      animationSetNum = 7,
      name = "Grocer 2"
   },
   [149]={
      animationDirection = "right",
      animationSetNum = 100,
      name = "Sheep"
   },
}

-- Inits character with starting animations
function Character:initialize(x, y, width, height, animationSetNumber, name)
   animationSet = Character:getAnimationSet(animationSetNumber)
   walkAnimation = Character:createWalkAnimation(animationSet)
   standAnimation = Character:createStandAnimation(animationSet)
   self.x = x
   self.y = y
   self.speed = Character.speed
   self.width = width
   self.height = height
   self.animationSet = animationSet
   self.walk = walkAnimation
   self.stand = standAnimation
   self.currentAnimation = walkAnimation.right
   self.currentAnimationType = "stand"
   self.currentAnimationDirection = "right"
   self.collider = nil
   self.is_mc = animationSetNum == 100000 -- TODO: remove this when I decouple NPCs from Character
   self.name = name
   self.animationSetNumber = animationSetNumber
end

-- Creates rectangle collider for character
function Character:createCharacterCollider()
   local collider = game.windfieldWorld:newBSGRectangleCollider(self.x, self.y, self.width, self.height-10, 10)
   collider:setFixedRotation(true)
   self.collider = collider
end

-- Adjusts character movement speed so diagonal movement appears natural
function Character:adjustDiagonalSpeed(horizontalPressed, horizontalPressed)
   if horizontalPressed and horizontalPressed then
      return self.speed/1.5
   else
      return self.speed
   end
end

-- Called when movement or standing is detected, to apply settings for animation type and direction.
function Character:prepareAnimation(direction, animationType)
   self.currentAnimationType = animationType
   self.currentAnimation = self.walk[direction]
   self.currentAnimationDirection = direction
   return self.stand[direction]
end

-- Applies keyboard movement with 'wasd' or arrow keys by altering x/y coords and applying walking
-- animation, or if x/y unchanged, applies standing animation.
function Character:move()
   if not self.collider then self:createCharacterCollider() end

   local upPressed = (love.keyboard.isDown("up") or love.keyboard.isDown("w"))
   local downPressed = (love.keyboard.isDown("down") or love.keyboard.isDown("s"))
   local leftPressed = (love.keyboard.isDown("left") or love.keyboard.isDown("a"))
   local rightPressed = (love.keyboard.isDown("right") or love.keyboard.isDown("d"))
   local verticalPressed = upPressed or downPressed
   local horizontalPressed = rightPressed or leftPressed
   local vx = 0
   local vy = 0
   local standAnimation = self:getStandAnimation()
   local speed = self:adjustDiagonalSpeed(horizontalPressed, verticalPressed)

   -- Diagonal movement start

   if horizontalPressed then
      if rightPressed then
         standAnimation = self:prepareAnimation("right", "walk")
         if self.x < game.mapW - self.height then
            vx = speed
         end
      elseif leftPressed then
         standAnimation = self:prepareAnimation("left", "walk")
         if self.x > 0 then
               vx = speed * -1
            end
      end
   end

   -- TODO: fix this bug: the following block overwrites the previous block every time,
   -- but we want to be able to move L and R diagonals without up/down animations
   if verticalPressed then
      if upPressed then
         standAnimation = self:prepareAnimation("up", "walk")
         if self.y > 20 then
            vy = speed * -1
         end
      elseif downPressed then
         standAnimation = self:prepareAnimation("down", "walk")
         if self.y < game.mapH - self.height then
            vy = speed
         end
      end
   end

   -- Diagonal movement end

   self:updateXY(vx, vy, standAnimation)
end

-- Helper function that updates XY and applies the standing animation if needed.
function Character:updateXY(vx, vy, standAnimation)
   self.collider:setLinearVelocity(vx, vy)
   -- offsets collider to make collisions appear natural
   local x = self.collider:getX() - 20
   local y = self.collider:getY() - 28

   if x == self.x and y == self.y then
      self.currentAnimation = standAnimation
      self.currentAnimationType = "stand"
   end

   self.x = x
   self.y = y
end

-- Returns an animation set for the main character, currently returned from Character:getAnimationSet method
function Character:mcAnimationSet()
   local gridPosition = '2-9'
   local startRow = 9
   local gridRepeat = nil
   local spriteSheet=lg.newImage(MC_SPRITESHEET)
   local grid=anim8.newGrid(64, 64, spriteSheet:getWidth(), spriteSheet:getHeight())
   local frameSpeed = 0.07

   return {
      walkDown=anim8.newAnimation(grid(gridPosition, startRow+2), frameSpeed),
      walkLeft=anim8.newAnimation(grid(gridPosition, startRow+1), frameSpeed),
      walkRight=anim8.newAnimation(grid(gridPosition, startRow+3), frameSpeed),
      walkUp=anim8.newAnimation(grid(gridPosition, startRow), frameSpeed),
      standDown=anim8.newAnimation(grid(1, startRow+2), 1),
      standLeft=anim8.newAnimation(grid(1, startRow+1), 1),
      standRight=anim8.newAnimation(grid(1, startRow+3), 1),
      standUp=anim8.newAnimation(grid(1, startRow), 1),
      spriteSheet=spriteSheet,
      grid=grid,
   }
end

-- Returns an animal animation set, currently returned from Character:getAnimationSet method
-- Note: there is currently only one animal in use, so when there are more, this will need to accept a set number
-- and determine startRow, gridPosition, etc like the Character:getAnimationSet method instead of hard coding.
-- TODO: Decouple NPCs from Character
function Character:animalAnimationSet()
   local gridPosition = '1-3'
   local startRow = 1
   local gridRepeat = 2
   local spriteSheet=lg.newImage(ANIMAL_SPRITESHEET_1)
   local grid=anim8.newGrid(48, 48, spriteSheet:getWidth(), spriteSheet:getHeight())
   local frameSpeed = 0.25

   return {
      walkDown=anim8.newAnimation(grid(gridPosition, startRow), frameSpeed),
      walkLeft=anim8.newAnimation(grid(gridPosition, startRow+1), frameSpeed),
      walkRight=anim8.newAnimation(grid(gridPosition, startRow+2), frameSpeed),
      walkUp=anim8.newAnimation(grid(gridPosition, startRow+3), frameSpeed),
      standDown=anim8.newAnimation(grid(1, startRow), 1),
      standLeft=anim8.newAnimation(grid(1, startRow+1), 1),
      standRight=anim8.newAnimation(grid(1, startRow+2), 1),
      standUp=anim8.newAnimation(grid(1, startRow), 1),
      spriteSheet=spriteSheet,
      grid=grid,
   }
end

-- Returns an animation set for the character based on set number
-- TODO: Decouple NPCs from Character
-- There is some hacky coding to get around the MC not having an NPC set number
function Character:getAnimationSet(set)
   -- MC set is 100000 until NPC is decoupled from Character
   if set == 100000 then
      return self:mcAnimationSet()
   end
   if set == 100 then
      return self.animalAnimationSet()
   end

   local spriteSheetRef = getSpriteSheetForSet(set)
   local startRow = getStartRow(set)
   local modulo = set % 4

   -- These are modulo 0 values
   local gridPosition = '10-12'
   local gridRepeat = 11

   if modulo == 1 then
      gridPosition = '1-3'
      gridRepeat = 2
   elseif modulo == 2 then
      gridPosition = '4-6'
      gridRepeat = 5
   elseif modulo == 3 then
      gridPosition = '7-9'
      gridRepeat = 8
   end

   local spriteSheet=lg.newImage(spriteSheetRef)
   local grid=anim8.newGrid(48, 72, spriteSheet:getWidth(), spriteSheet:getHeight())
   return {
      standDown=anim8.newAnimation(grid(gridRepeat, startRow), 1),
      standLeft=anim8.newAnimation(grid(gridRepeat, startRow+1), 1),
      standRight=anim8.newAnimation(grid(gridRepeat, startRow+2), 1),
      standUp=anim8.newAnimation(grid(gridRepeat, startRow+3), 1),
      walkDown=anim8.newAnimation(grid(gridPosition, startRow, gridRepeat, startRow), 0.25),
      walkLeft=anim8.newAnimation(grid(gridPosition, startRow+1, gridRepeat, startRow+1), 0.25),
      walkRight=anim8.newAnimation(grid(gridPosition, startRow+2, gridRepeat, startRow+2), 0.25),
      walkUp=anim8.newAnimation(grid(gridPosition, startRow+3, gridRepeat, startRow+3), 0.25),
      spriteSheet=spriteSheet,
      grid=grid,
   }
end

-- Gets spritesheet for the character
function Character:getSpriteSheet()
   return self.animationSet.spriteSheet
end

-- Creates a walk animation set with four directions
function Character:createWalkAnimation(animationSet)
   return {
      up=animationSet.walkUp, 
      down=animationSet.walkDown, 
      left=animationSet.walkLeft, 
      right=animationSet.walkRight
   }
end

-- Returns stand animation in the correct direction
function Character:getStandAnimation()
   return self.stand[self.currentAnimationDirection]
end

-- Creates a stand animation set with four directions
function Character:createStandAnimation(animationSet)
   return {
      up=animationSet.standUp, 
      down=animationSet.standDown, 
      left=animationSet.standLeft, 
      right=animationSet.standRight
   }
end

-- Sets animation based on a string
-- TODO: making a table for mapping would be more Lua-like
function Character:setCurrentAnimation(anim)
   if anim == "walkRight" then
      self.currentAnimation = self.walk.right
   elseif anim == "walkLeft" then
      self.currentAnimation = self.walk.left
   elseif anim == "walkUp" then
      self.currentAnimation = self.walk.up
   elseif anim == "walkDown" then
      self.currentAnimation = self.walk.down
   elseif anim == "standRight" then
      self.currentAnimation = self.stand.right
   elseif anim == "standLeft" then
      self.currentAnimation = self.stand.left
   elseif anim == "standUp" then
      self.currentAnimation = self.stand.up
   elseif anim == "standDown" then
      self.currentAnimation = self.stand.down
   end
end

-- Determines first row to use in character spritesheet based on set number
function getStartRow(set)
   local startRow = 1
   if set < 5 then
      return startRow
   end
   if set > 8 and set < 13 then
      return startRow
   end
   if set > 16 and set < 21 then
      return startRow
   end
   if set > 24 then
      return startRow
   end
   return (startRow + 4)
end

-- Maps spritesheet to set number
function getSpriteSheetForSet(set)
   if set < 9 then 
      return SET_1_SPRITESHEET 
   end
   if set < 17 then
      return SET_2_SPRITESHEET
   end
   if set < 25 then
      return SET_3_SPRITESHEET
   end
   return SET_4_SPRITESHEET
end
