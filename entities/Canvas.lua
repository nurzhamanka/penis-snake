local Class = require "libraries.class"
local Entity = require "entities.Entity"

local Canvas = Class {
    __includes = Entity
}

function Canvas:init(cw, ch, gw, gh)
    -- create a canvas with width cwXch, grid size gwXgh
    Entity:init(0, 0, cw, ch)
    self.gridcanvas = love.graphics.newCanvas()
    for i=0, cw-1 do
        love.graphics.setCanvas(self.gridcanvas)
		for j=0, ch-1 do
            love.graphics.setColor(1, 1, 1, 0.3)
			love.graphics.rectangle("line", i*gw, j*gh, gw, gh)
		end
    end
    love.graphics.setCanvas()
end

function Canvas:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.gridcanvas)
end

return Canvas
