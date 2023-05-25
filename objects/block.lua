local class = require 'libraries/middleclass'

Block = class('Block')

function Block:initialize(x, y, height, width)
   self.x = x
   self.y = y
   self.height = height
   self.width = width
end