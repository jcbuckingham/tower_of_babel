local class = require 'libraries/middleclass'
SET_1_SPRITESHEET = "assets/sprites/re_cv_sprites_v1_0_by_doubleleggy_d2hwj7w.png"
SET_2_SPRITESHEET = "assets/sprites/re2_sprites_v1_1_by_doubleleggy_d2qb57d.png"

Character = class('Character')

function Character:initialize(x, y, speed, animationSetNum)
   animationSet = Character:getAnimationSet(animationSetNum)
   walkAnimation = Character:createWalkAnimation(animationSet)
   self.x = x
   self.y = y
   self.speed = speed
   self.width = 32
   self.height = 32
   self.animationSet = animationSet
   self.walk = walkAnimation
   self.currentAnimation = walkAnimation.right
end

-- function Character:setupAnimation()
--    self.walk = self:setWalkAnimation()
--    self.currentAnimation = self.animationSet.walkRight
-- end

function Character:move()
   if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
      self.currentAnimation = self.walk.right
      if self.x < _G.w - self.width*1.5 then
         self.x = self.x + self.speed
      end
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
      self.currentAnimation = self.walk.left   
      if self.x > 0 then
            self.x = self.x - self.speed
         end
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      self.currentAnimation = self.walk.up
      if self.y > 5 then
         self.y = self.y - self.speed
      end
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      self.currentAnimation = self.walk.down
      if self.y < _G.h - 55 then
         self.y = self.y + self.speed
      end
    end
end

function Character:getAnimationSet(set)
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

function Character:setCurrentAnimation(anim)
   if anim == "walkRight" then
      self.currentAnimation = self.walk.right
   elseif anim == "walkLeft" then
      self.currentAnimation = self.walk.left
   elseif anim == "walkUp" then
      self.currentAnimation = self.walk.up
   elseif anim == "walkDown" then
      self.currentAnimation = self.walk.down
   end
end
