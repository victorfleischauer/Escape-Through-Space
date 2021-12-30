push = require 'push'

Class = require 'class'

require 'StateMachine'

require 'states/BaseState'
require 'states/PlayState'
require 'states/StartState'
require 'states/ResultsState'

require 'Player'
require 'Enemy'
require 'Tiro'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 324
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('imgs/space.png')
local stars = love.graphics.newImage('imgs/stars.png')
local starScroll = -1000 + VIRTUAL_HEIGHT
local starSpeed = 60

function love.load ()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- fonts
    titleFont = love.graphics.newFont('Linebeam.ttf', 30)
    menuFont = love.graphics.newFont('ARCADECLASSIC.TTF', 20)
    timerFont = love.graphics.newFont('Open 24 Display St.ttf', 20)

    -- app window title
    love.window.setTitle('Escape Through Space')

    -- hide mouse
    love.mouse.setVisible(false)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['results'] = function() return ResultsState() end
    }
    gStateMachine:change('start')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    starScroll = (starScroll + starSpeed * dt)
    if starScroll >= 0 then
        starScroll = -1000 + VIRTUAL_HEIGHT
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(stars, 0, starScroll)

    gStateMachine:render()

    push:finish()
end