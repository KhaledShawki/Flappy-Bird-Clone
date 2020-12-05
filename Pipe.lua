Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')
 


function Pipe:init(orientation, y)
    
    self.x = VIRTUAL_WIDTH 

    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()

    self.orientation = orientation
end

function Pipe:update(dt)
end

function Pipe:render()

    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, -- rotation
        1, -- X scale
        self.orientation == 'top' and -1 or 1) -- Y scale. 
        -- if is top set y scale to -1 to  mirror the image on the y axis 
end