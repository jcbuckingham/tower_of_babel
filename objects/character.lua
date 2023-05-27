local class = require 'libraries/middleclass'
SET_1_SPRITESHEET = "assets/sprites/villager-females.png"
SET_2_SPRITESHEET = "assets/sprites/villager-males_1.png"
SET_3_SPRITESHEET = "assets/sprites/armored-npcs.png"
SET_4_SPRITESHEET = "assets/sprites/male-leather-armor-set_1.png"

MC_SPRITESHEET = "assets/sprites/senlin.png"

Character = class('Character')

Character.static.scale = 1.6
Character.static.offset = 23
Character.static.speed = 250
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
   }
}

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
   self.is_mc = animationSetNum == 100000
   self.name = name
   self.animationSetNumber = animationSetNumber
end

function Character:getStandAnimation()
   return self.stand[self.currentAnimationDirection]
end

function Character:createCharacterCollider()
   local collider = game.windfieldWorld:newBSGRectangleCollider(self.x, self.y, self.width, self.height-10, 10)
   collider:setFixedRotation(true)
   self.collider = collider
end

function Character:adjustDiagonalSpeed(horizontalPressed, horizontalPressed)
   if horizontalPressed and horizontalPressed then
      return self.speed/1.5
   else
      return self.speed
   end
end

function Character:prepareAnimation(direction, animationType)
   self.currentAnimationType = animationType
   self.currentAnimation = self.walk[direction]
   self.currentAnimationDirection = direction
   return self.stand[direction]
end

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

   self:updateXY(vx, vy, standAnimation)
end

function Character:updateXY(vx, vy, standAnimation)
   self.collider:setLinearVelocity(vx, vy)
   local x = self.collider:getX() - 24
   local y = self.collider:getY() - 28
   if x == self.x and y == self.y then
      self.currentAnimation = standAnimation
      self.currentAnimationType = "stand"
   end

   self.x = self.collider:getX() - 24
   self.y = self.collider:getY() - 28
end

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

function Character:getAnimationSet(set)
   -- MC set is 100000
   if set == 100000 then
      return self:mcAnimationSet()
   end

   local spriteSheetRef = getSpriteSheetForSet(set)
   local startRow = getStartRow(set)
   local modulo = set % 4

   -- modulo 0 values
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

function Character:getGrid()
   return self.animationSet.grid
end

function Character:getSpriteSheet()
   return self.animationSet.spriteSheet
end

function Character:createWalkAnimation(animationSet)
   return {
      up=animationSet.walkUp, 
      down=animationSet.walkDown, 
      left=animationSet.walkLeft, 
      right=animationSet.walkRight
   }
end

function Character:createStandAnimation(animationSet)
   return {
      up=animationSet.standUp, 
      down=animationSet.standDown, 
      left=animationSet.standLeft, 
      right=animationSet.standRight
   }
end

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

function getStartRow(set)
   local startRow = 1
   if set > 24 then
      return startRow
   end
   if set < 5 then
      return startRow
   end
   if set > 8 and set < 13 then
      return startRow
   end
   if set > 16 and set < 21 then
      return startRow
   end
   return (startRow + 4)
end

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
