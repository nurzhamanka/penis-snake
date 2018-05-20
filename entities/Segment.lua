local Class = require "libraries.class"
local Entity = require "entities.Entity"

local Segment = Class {
    __includes = Entity
}

function Segment:init(prev)
    self.prev = prev or nil
    self.next = nil
    if prev ~= nil then
        prev.next = self
    end
    self.size = 1
    if (self.prev == nil) then
        -- this is the head
        local x = math.random(0, MAP_SIZE-1) * 16
        local y = math.random(0, MAP_SIZE-1) * 16
        Entity.init(self, x, y, 16, 16)
        print(tostring(self.x))
        self.vx = 0
        self.vy = 0
    else
        -- this is a segment
        local _prev = self.prev
        Entity.init(self, _prev.x0, _prev.y0, 16, 16)
        self.vx = _prev.vx
        self.vy = _prev.vy
    end
end

function Segment:update()
    self.x0 = self.x
    self.y0 = self.y
    self.vx0 = self.vx
    self.vy0 = self.vy
    if (self.prev == nil) then
        local x = self.x + self.w * self.vx
        local y = self.y + self.h * self.vy
        self:setPos(x, y)
    else
        local vx = self.prev.vx0
        local vy = self.prev.vy0
        self:setSpeed(vx, vy)
        local x = self.prev.x0
        local y = self.prev.y0
        self:setPos(x, y)
    end

    -- horizontal wrap
    if self.x >= love.graphics.getWidth() then
        self.x = 0
    elseif self.x < 0 then
        self.x = love.graphics.getWidth() - self.w
    end

    -- vertical wrap
    if self.y >= love.graphics.getHeight() then
        self.y = 0
    elseif self.y < 0 then
        self.y = love.graphics.getHeight() - self.h
    end
end

function Segment:setSpeed(vx, vy)
    self.vx = vx
    self.vy = vy
end

function Segment:setPos(x, y)
    self.x = x
    self.y = y
end

function Segment:signalSize(size)
    self.size = size
end

function Segment:draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- draw body
    love.graphics.rectangle("fill", self:getRect())
    -- draw nose
    if self.prev == nil then
        if self.vx == 1 then -- right
            local x = self.x + self.w
            love.graphics.polygon("fill", x, self.y-2, x, self.y+self.h+2, x+8, self.y+self.h/2)
        elseif self.vx == -1 then -- left
            local x = self.x
            love.graphics.polygon("fill", x-8, self.y+self.h/2, x, self.y-2, x, self.y+self.h+2)
        elseif self.vy == -1 then -- up
            local y = self.y
            love.graphics.polygon("fill", self.x-2, y, self.x+self.w+2, y, self.x+self.w/2, y-8)
        else -- down
            local y = self.y + self.h
            love.graphics.polygon("fill", self.x-2, y, self.x+self.w/2, y+8, self.x+self.w+2, y)
        end
    end
    -- draw ballz
    BALL_SIZE = self.size
    if self.next == nil then
        if self.vx == 1 then -- right
            local x = self.x
            local y = self.y
            love.graphics.circle("fill", x, y+2-BALL_SIZE/2, BALL_SIZE)
            love.graphics.circle("fill", x, y+self.h-2+BALL_SIZE/2, BALL_SIZE)
        elseif self.vx == -1 then -- left
            local x = self.x + self.w
            local y = self.y
            love.graphics.circle("fill", x, y+2-BALL_SIZE/2, BALL_SIZE)
            love.graphics.circle("fill", x, y+self.h-2+BALL_SIZE/2, BALL_SIZE)
        elseif self.vy == -1 then -- up
            local x = self.x
            local y = self.y + self.h
            love.graphics.circle("fill", x+2-BALL_SIZE/2, y, BALL_SIZE)
            love.graphics.circle("fill", x+self.w-2+BALL_SIZE/2, y, BALL_SIZE)
        else -- down
            local x = self.x
            local y = self.y
            love.graphics.circle("fill", x+2-BALL_SIZE/2, y, BALL_SIZE)
            love.graphics.circle("fill", x+self.w-2+BALL_SIZE/2, y, BALL_SIZE)
        end
    end
end

return Segment
