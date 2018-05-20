Gamestate = require "libraries.gamestate"

local main_menu = require "gamestates.MainMenu"
local game = require "gamestates.Game"
local pause = require "gamestates.Pause"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(main_menu, -1)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end
