local Gamestate = require "libraries.gamestate"

local Pause = {}

function Pause:enter(from)
    self.from = from
    self.font = love.graphics.newFont("assets/vcr.ttf", 14)
end

function Pause:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  -- draw previous screen
  self.from:draw()

  -- overlay with pause message
  love.graphics.setFont(self.font)
  love.graphics.setColor(0,0,0, 0.5)
  love.graphics.rectangle('fill', 0, 0, w, h)
  love.graphics.setColor(255,255,255)
  love.graphics.printf('PAUSE\n\nmove to resume', 0, h/2, w, 'center')
end

function Pause:keypressed(key)
  if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
    return Gamestate.pop() -- return to previous state
  end
end

return Pause
