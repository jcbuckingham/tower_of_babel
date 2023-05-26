local class = require 'libraries/middleclass'
SET_1_SPRITESHEET = "assets/sprites/re_cv_sprites_v1_0_by_doubleleggy_d2hwj7w.png"
SET_2_SPRITESHEET = "assets/sprites/re2_sprites_v1_1_by_doubleleggy_d2qb57d.png"
MC_SPRITESHEET = "assets/sprites/senlin.png"

Character = class('Character')

Character.static.scale = 1.6
Character.static.offset = 23

function Character:initialize(x, y, speed, animationSetNum)
   animationSet = Character:getAnimationSet(animationSetNum)
   walkAnimation = Character:createWalkAnimation(animationSet)
   standAnimation = Character:createStandAnimation(animationSet)
   self.x = x
   self.y = y
   self.speed = speed
   self.width = 30
   self.height = 50
   self.animationSet = animationSet
   self.walk = walkAnimation
   self.stand = standAnimation
   self.currentAnimation = walkAnimation.right
   self.currentAnimationType = "walk"
   self.currentAnimationDirection = "right"
   self.collider = nil
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

function Character:prepareAnimation(direction)
   self.currentAnimationType = "walk"
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
         standAnimation = self:prepareAnimation("right")
         if self.x < game.mapW - self.height then
            vx = speed
         end
      elseif leftPressed then
         standAnimation = self:prepareAnimation("left")
         if self.x > 0 then
               vx = speed * -1
            end
      end
   end

   if verticalPressed then
      if upPressed then
         standAnimation = self:prepareAnimation("up")
         if self.y > 20 then
            vy = speed * -1
         end
      elseif downPressed then
         standAnimation = self:prepareAnimation("down")
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

function Character:getAnimationSet(set)
   -- MC set is
   if set == 1000 then
      gridPosition = '2-9'
      startRow = 9
      gridRepeat = nil

      spriteSheet=lg.newImage(MC_SPRITESHEET)
      grid=anim8.newGrid(64, 64, spriteSheet:getWidth(), spriteSheet:getHeight())
      return {
         walkDown=anim8.newAnimation(grid(gridPosition, startRow+2), 0.07),
         walkLeft=anim8.newAnimation(grid(gridPosition, startRow+1), 0.07),
         walkRight=anim8.newAnimation(grid(gridPosition, startRow+3), 0.07),
         walkUp=anim8.newAnimation(grid(gridPosition, startRow), 0.07),
         standDown=anim8.newAnimation(grid(1, startRow+2), 1),
         standLeft=anim8.newAnimation(grid(1, startRow+1), 1),
         standRight=anim8.newAnimation(grid(1, startRow+3), 1),
         standUp=anim8.newAnimation(grid(1, startRow), 1),
         spriteSheet=spriteSheet,
         grid=grid,
      }
   end

   if set < 8 then 
      spriteSheet = SET_1_SPRITESHEET 
   else 
      spriteSheet = SET_2_SPRITESHEET 
   end
   if set < 5 or (7 < set and set < 12) then
      startRow = 1
   else
      startRow = 5
   end

   if set == 1 or set == 5 or set == 8 or set == 12 then
      gridPosition = '1-3'
      gridRepeat = 2
   elseif set == 2 or set == 6 or set == 9 or set == 13 then
      gridPosition = '4-6'
      gridRepeat = 5
   elseif set == 3 or set == 7 or set == 10 or set == 14 then
      gridPosition = '7-9'
      gridRepeat = 8
   elseif set == 4 or set == 11 or set == 15 then
      gridPosition = '10-12'
      gridRepeat = 11
   end

   spriteSheet=lg.newImage(spriteSheet)
   grid=anim8.newGrid(32, 32, spriteSheet:getWidth(), spriteSheet:getHeight())
   return {
      walkDown=anim8.newAnimation(grid(gridPosition, startRow, gridRepeat, startRow), 0.25),
      walkLeft=anim8.newAnimation(grid(gridPosition, startRow+1, gridRepeat, startRow+1), 0.25),
      walkRight=anim8.newAnimation(grid(gridPosition, startRow+2, gridRepeat, startRow+2), 0.25),
      walkUp=anim8.newAnimation(grid(gridPosition, startRow+3, gridRepeat, startRow+3), 0.25),
      standDown=anim8.newAnimation(grid(gridRepeat-1, startRow), 1),
      standLeft=anim8.newAnimation(grid(gridRepeat-1, startRow+1), 1),
      standRight=anim8.newAnimation(grid(gridRepeat-1, startRow+2), 1),
      standUp=anim8.newAnimation(grid(gridRepeat-1, startRow+3), 1),
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
