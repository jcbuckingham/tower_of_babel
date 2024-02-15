require 'helpers/utils'
local class = require 'libraries/middleclass'

SET_1_SPRITESHEET = "assets/sprites/villager-females.png"
SET_2_SPRITESHEET = "assets/sprites/villager-males_1.png"
SET_3_SPRITESHEET = "assets/sprites/armored-npcs.png"
SET_4_SPRITESHEET = "assets/sprites/male-leather-armor-set_1.png"
ANIMAL_SPRITESHEET_1 = "assets/sprites/animal_sprites_1.png"

--add animal set numbers here
ANIMAL_ANIMATION_SETS = {
    100
} 

-- Inherit from Character
NPC = class('NPC', Character)

-- TODO: move large static data to separate files
NPC.static.npcData = {
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

-- Inits NPC with starting animations
function NPC:initialize(x, y, width, height, animationSetNumber, name)
   animationSet = NPC:getAnimationSet(animationSetNumber)
   walkAnimation = NPC:createWalkAnimation(animationSet)
   standAnimation = NPC:createStandAnimation(animationSet)
   self.x = x
   self.y = y
   self.speed = NPC.speed
   self.width = width
   self.height = height
   self.animationSet = animationSet
   self.walk = walkAnimation
   self.stand = standAnimation
   self.currentAnimation = walkAnimation.right
   self.currentAnimationType = "stand"
   self.currentAnimationDirection = "right"
   self.collider = nil
   self.name = name
   self.animationSetNumber = animationSetNumber
end

-- Returns an animal animation set, currently returned from NPC:getAnimationSet method
-- Note: there is currently only one animal in use, so when there are more, this will need to 
-- determine startRow, gridPosition, etc like the NPC:getAnimationSet method instead of hard coding.
function NPC:animalAnimationSet(set)
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

-- Returns an animation set for the NPC based on set number
function NPC:getAnimationSet(set)
   if contains(ANIMAL_ANIMATION_SETS, set) then
      return self.animalAnimationSet(set)
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

-- Determines first row to use in NPC spritesheet based on set number
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
