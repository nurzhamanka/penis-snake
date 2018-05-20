local Class = require "libraries.class"

local Entity = Class {}

function Entity:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Entity:getRect()
    return self.x, self.y, self.w, self.h
end

function Entity:update(dt)
end

function Entity:draw()
end

return Entity
