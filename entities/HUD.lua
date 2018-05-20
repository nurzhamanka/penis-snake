local Class = require "libraries.class"
local Entity = require "entities.Entity"

local HUD = Class {
    __includes = Entity
}

function HUD:init()
    Entity.init(self, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    self.font = love.graphics.newFont("assets/vcr.ttf", 14)
    self.score = 1
end

function HUD:addScore()
    self.score = self.score + 1
end

function HUD:draw()
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(self.font)
    love.graphics.printf("PINGAS SIZE: " .. tostring(self.score) .. " cm", 16, 16, self.w, 'left')
end

return HUD
