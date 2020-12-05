ScoreState = Class {__includes = BaseState}

local BRONZE_MEDAL = love.graphics.newImage('images/bronze.png')
local SILVER_MEDAL = love.graphics.newImage('images/silver.png')
local GOLD_MEDAL = love.graphics.newImage('images/gold.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)

    if love.keyboard.wasPressed('enter') or  love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()

    love.graphics.setFont(flappyFont)
    love.graphics.printf('You lost :-(', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')

    if self.score > 4 then
		love.graphics.draw(GOLD_MEDAL, VIRTUAL_WIDTH / 2 - GOLD_MEDAL:getHeight() / 2, 180, 0, 0.3, 0.3)
	elseif self.score > 2 then
		love.graphics.draw(SILVER_MEDAL, VIRTUAL_WIDTH / 2 - SILVER_MEDAL:getHeight() / 2, 180, 0, 0.3, 0.3)
	elseif self.score > 0 then
		love.graphics.draw(BRONZE_MEDAL, VIRTUAL_WIDTH / 2 - BRONZE_MEDAL:getHeight() / 2, 180, 0, 0.3, 0.3)
    end
    
end