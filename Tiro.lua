Tiro = Class{}

local SPEED = 1000
local imageVertical = love.graphics.newImage('imgs/tiro.png')
local imageHorizontal = love.graphics.newImage('imgs/tiroHorizontal.png')

function Tiro:init(x, y, direction)
    self.x = x
    self.y = y

    self.width = imageVertical:getWidth()
    self.height = imageVertical:getHeight()
    
    self.direction = direction

    self.remove = false
end

function Tiro:update(dt)
    case = {
        ['Up'] = function ()
            self.y = self.y - SPEED * dt
        end,
        ['Down'] = function ()
            self.y = self.y + SPEED * dt
        end,
        ['Left'] = function ()
            self.x = self.x - SPEED * dt
        end,
        ['Right'] = function ()
            self.x = self.x + SPEED * dt
        end
    }

    case[self.direction]()

    -- check if is fully out of the screen
    if self.x > VIRTUAL_WIDTH then
        self.remove = true
    elseif self.x < -self.width then
        self.remove = true
    elseif self.y > VIRTUAL_HEIGHT then
        self.remove = true
    elseif self.y < -self.height then
        self.remove = true
    end
end


function Tiro:collides(enemy)
    if (self.x) + (self.width) >= enemy.x and self.x <= enemy.x + ENEMY_SIDE_LENGTH then
        if (self.y) + (self.height) >= enemy.y and self.y <= enemy.y + ENEMY_SIDE_LENGTH then
            self.remove = true
            return true
        end
    end
end

function Tiro:render()
    if self.direction == 'Up' then
        love.graphics.draw(imageVertical, self.x, self.y)
    elseif self.direction == 'Down' then
        love.graphics.draw(imageVertical, self.x, self.y + self.height, 0, 1, -1)
    elseif self.direction == 'Left' then
        love.graphics.draw(imageHorizontal, self.x + self.width, self.y, 0, -1, 1)
    elseif self.direction == 'Right' then
        love.graphics.draw(imageHorizontal, self.x, self.y)
    end
end