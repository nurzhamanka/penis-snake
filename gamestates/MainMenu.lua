local Gamestate = require "libraries.gamestate"

local MainMenu = {}
local game = require "gamestates.Game"

function MainMenu:enter(from, score)
    if score == -1 then self.from = nil
    else self.from = from
    end

    self.fontSmall = love.graphics.newFont("assets/vcr.ttf", 11)
    self.fontMedium = love.graphics.newFont("assets/vcr.ttf", 14)
    self.fontBig = love.graphics.newFont("assets/vcr.ttf", 20)
    self.score = score or nil
end

function MainMenu:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()

  -- overlay with pause message
  love.graphics.setColor(0,0,0, 1)
  love.graphics.rectangle('fill', 0, 0, w, h)
  love.graphics.setColor(255,255,255)
  if self.from ~= nil then
      love.graphics.setFont(self.fontBig)
      love.graphics.printf('GAME OVER!', 0, h/2, w, 'center')
      love.graphics.setFont(self.fontMedium)
      love.graphics.printf('your pingas was ' .. self.score .. " cm", 0, h/2 + 30, w, 'center')
      love.graphics.setFont(self.fontSmall)
      love.graphics.printf('press ENTER to try again!', 0, h/2 + 30 + 20, w, 'center')
  else
      love.graphics.setFont(self.fontBig)
      love.graphics.printf('Nurzhan\'s Shitty Snake!', 0, h/2, w, 'center')
      love.graphics.setFont(self.fontMedium)
      love.graphics.printf("press ENTER to start!", 0, h/2 + 30, w, 'center')
  end
end

function MainMenu:keypressed(key)
  if key == 'return' then
    Gamestate.switch(game)
  end
end

return MainMenu
