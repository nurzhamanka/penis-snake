-- libraries
local Cron = require "libraries.cron"
local Gamestate = require "libraries.gamestate"

-- entity system
local Entities = require "entities.Entities"
local Entity = require "entities.Entity"

-- gamestate
local Game = {}

-- entities
local Segment = require "entities.Segment"
local Food = require "entities.Food"
local Canvas = require "entities.Canvas"
local HUD = require "entities.HUD"

-- variables
MAP_SIZE = love.graphics.getWidth() / 16

function Game:enter()
    -- gamestates
    self.main_menu = require "gamestates.MainMenu"
    self.pause = require "gamestates.Pause"

    -- initialize the randomizer
    math.randomseed(os.time())

    -- music initializer
    music_game = love.audio.newSource("music/FINAL_CROPPED.wav", "static")
    music_death = love.audio.newSource("music/death.wav", "static")
    sound_food = love.audio.newSource("sfx/food.wav", "static")
    music_game:setLooping(true)

    -- initialize the entity system
    Entities:clear()

    snake = {}
    items = {}
    is_alive = true
    has_died = false
    can_input = true

    -- create the canvas
    canvas = Canvas(MAP_SIZE, MAP_SIZE, 16, 16)
    Entities:add(canvas)

    -- create the snake
    head = Segment()
    table.insert(snake, head)
    Entities:add(head)

    -- create a food piece
    self:createItem()

    -- create the HUD
    hud = HUD()
    Entities:add(hud)

    music_game:play()

    -- update the snake periodically
    clock_snake = Cron.every(0.1, function()
        can_input = true
        for i, segment in ipairs(snake) do
            if i > 3 then
                if (segment.x == head.x and segment.y == head.y) then
                    self:game_over()
                end
            end
        end
        Entities:update()
    end)
end

function Game:update(dt)
    self:input()
    if is_alive == false then
        if has_died == false then
            clock_death:update(dt)
        end
        if #snake == 0 then
            clock_reload:update(dt)
        end
    else
        clock_snake:update(dt)
    end
    for _, item in ipairs(items) do
        if item.x == head.x and item.y == head.y then
            self:destroyItem(item)
            sound_food:play()
            self:grow()
            hud:addScore()
        end
    end
end

function Game:draw()
    Entities:draw()
end

function Game:input()
    if can_input == false then return end
    can_input = false
    if (love.keyboard.isDown("left") and (head.vx ~= 1 or #snake == 1)) then
        head:setSpeed(-1, 0)
    elseif (love.keyboard.isDown("right") and (head.vx ~= -1 or #snake == 1))  then
        head:setSpeed(1, 0)
    elseif (love.keyboard.isDown("up") and (head.vy ~= 1 or #snake == 1))  then
        head:setSpeed(0, -1)
    elseif (love.keyboard.isDown("down") and (head.vy ~= -1 or #snake == 1))  then
        head:setSpeed(0, 1)
    elseif love.keyboard.isDown("space") then
        self:grow()
    elseif love.keyboard.isDown("p") then
        Gamestate.push(self.pause)
    end
end

function Game:grow()
    local segment = Segment(snake[#snake])
    segment:signalSize(#snake)
    table.insert(snake, segment)
    Entities:add(segment)
end

function Game:game_over()
    is_alive = false
    music_game:stop()
    duration = music_death:getDuration("seconds") - 1
    death_interval = duration / #snake
    music_death:play()
    -- stop the snake
    for i, segment in ipairs(snake) do
        segment:setSpeed(0, 0)
    end
    local score = #snake
    clock_death = Cron.every(death_interval, function()
        Entities:remove(snake[#snake])
        table.remove(snake, #snake)
        if #snake == 0 then
            has_died = true
            clock_reload = Cron.after(2, function() Gamestate.switch(self.main_menu, score) end)
        end
    end)
    can_input = false
end

function Game:createItem()
    if (#items > 0) then return end
    local food = Food()
    table.insert(items, food)
    Entities:add(food)
end

function Game:destroyItem(item)
    Entities:remove(item)
    for i, value in ipairs(items) do
      if value == item then
        table.remove(items, i)
        self.createItem()
      end
    end
end

return Game
