local class = require 'libraries/middleclass'
MC_SPRITESHEET = "assets/sprites/senlin.png"
MC_NAME = "Senlin"

Character = class('Character')

Character.static.scale = 1.6
Character.static.offset = 23
Character.static.speed = 250

-- Inits character with starting animations
function Character:initialize(x, y, width, height)
   animationSet = Character:getAnimationSet()
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
   self.name = MC_NAME
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

-- Returns an animation set for the character
function Character:getAnimationSet()
   return self.mcAnimationSet()
end