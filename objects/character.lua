local class = require 'libraries/middleclass'
SET_1_SPRITESHEET = "assets/sprites/re_side_character_sprites_v1_0_by_doubleleggy_d2hz61y.png"

Character = class('Character')

function Character:initialize(x, y, speed, animationSetNum)
   animSet = Character:getAnimationSet(animationSetNum)
   walkAnim = Character:createWalkAnimation(animSet)
   self.x = x
   self.y = y
   self.speed = speed
   self.width = 32
   self.height = 32
   self.animationSet = animSet
   self.walk = walkAnim
   self.currentAnimation = walkAnim.right
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
   if set == 1 then
      spriteSheet=lg.newImage(SET_1_SPRITESHEET)
      grid=anim8.newGrid(32, 32, spriteSheet:getWidth(), spriteSheet:getHeight())
      return {
         walkDown=anim8.newAnimation(grid('1-3', 1), 0.25),
         walkUp=anim8.newAnimation(grid('1-3', 4), 0.25),
         walkLeft=anim8.newAnimation(grid('1-3', 2), 0.25),
         walkRight=anim8.newAnimation(grid('1-3', 3), 0.25),
         spriteSheet=spriteSheet,
         grid=grid,
      }
   end
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
      self.currentAnimation = self.walk["right"]
   elseif anim == "walkLeft" then
      self.currentAnimation = self.walk["left"]
   elseif anim == "walkUp" then
      self.currentAnimation = self.walk["up"]
   elseif anim == "walkDown" then
      self.currentAnimation = self.walk["down"]
   end
end
