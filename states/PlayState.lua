PlayState = Class {__includes = BaseState}

local PAUSE_IMAGE = love.graphics.newImage('images/pause.png')

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHJT = 24

function PlayState:init()

    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    self.interval = math.random(2, 6)
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('p') then pause = not pause end

    if pause then
        sounds['music']:pause()
    else
        sounds['music']:play()
    end

    if not pause then
        self.timer = self.timer + dt
       
        if self.timer > self.interval then
            local y = math.max(-PIPE_HEIGHT + 10, math.min(
                                   self.lastY + math.random(-20, 20),
                                   VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y

            table.insert(self.pipePairs, PipePair(y))
            self.interval = math.random(2, 6)
            self.timer = 0
        end

        for k, pair in pairs(self.pipePairs) do
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end
            pair:update(dt)
        end

        for k, pair in pairs(self.pipePairs) do
            if pair.remove then table.remove(self.pipePairs, k) end
        end

        self.bird:update(dt)

        for k, pair in pairs(self.pipePairs) do

            -- check if bird collided with pipe
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    -- pause the game
                    gStateMachine:change('score', {score = self.score})
                end
            end
        end

        -- change the state if we hit the ground
        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {score = self.score})
        end
    end

end

function PlayState:render()

    for k, pair in pairs(self.pipePairs) do
        -- render the pipe pair
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('score: ' .. tostring(self.score), 8, 8)
    if pause then
        love.graphics.draw(PAUSE_IMAGE, VIRTUAL_WIDTH / 2 - (PAUSE_IMAGE:getWidth() / 2) ,VIRTUAL_HEIGHT / 2 - (PAUSE_IMAGE:getHeight() / 2))
    end
    self.bird:render()
end
