push = require 'push'

-- OOP library
Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'Statemachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOWS_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("images/background.png")
local backgroundScroll = 0

local ground = love.graphics.newImage("images/ground.png")
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = BACKGROUND_SCROLL_SPEED * 2

local BACKGROUND_LOOPING_POINT = 413

function love.load()

    love.graphics.setDefaultFilter('nearest', "nearest")

    -- window title
    love.window.setTitle('Flappy Bird')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- seed the RNG
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH,
                     WINDOWS_HEIGHT,
                     {vsync = true, fullscreen = false, resizable = true})

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }

    gStateMachine:change('title')

    pause = false

    -- input table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h) push:resize(w, h) end

function love.keyboard.wasPressed(key) return love.keyboard.keysPressed[key] end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if (key == 'escape') then love.event.quit() end
end

function love.mousepressed(x, y, button) love.mouse.buttonsPressed[button] =
    true end

function love.mouse.wasPressed(button) return love.mouse.buttonsPressed[button] end

function love.update(dt)
    if not pause then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) %
                               BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end
    gStateMachine:update(dt)

    -- reset keysPressed table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()

    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end