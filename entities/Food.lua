local Class = require "libraries.class"
local Entity = require "entities.Entity"
local Cron = require "libraries.cron"

local Food = Class {
    __includes = Entity
}

function Food:init()
    local x = math.random(0, MAP_SIZE-1) * 16
    local y = math.random(0, MAP_SIZE-1) * 16
    Entity.init(self, x, y, 8, 8)
    self.visible = 1
    clock_food = Cron.every(0.4, function ()
        if self.visible == 1 then self.visible = 0.3
        else self.visible = 1
        end
    end)
end

function Food:update()
    clock_food:update(0.1)
end

function Food:draw()
    love.graphics.setColor(1, 0, 0, self.visible)
    love.graphics.rectangle("fill", self.x + self.w/2, self.y + self.h/2, self.w, self.h)
end

return Food
