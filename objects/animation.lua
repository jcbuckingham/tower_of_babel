Animation = {}

function Animation:new(obj, up, down, left, right)
   obj = obj or {}
   setmetatable(ob, self)
   self.__index = self
   self.up = up
   self.down = down
   self.left = left
   self.right = right
end