Enemy = Class{}

-- local love.graphics.newImage('imgs/Enemy.png')

ENEMY_SIDE_LENGTH = 16

local SPEED = 15

function Enemy:init(x, y)
    self.x = x
    self.y = y

end

function Enemy:update(dt)
    
    self.x = self.x + SPEED * dt

end

function Enemy:render()
    love.graphics.rectangle('fill', self.x, self.y, ENEMY_SIDE_LENGTH, ENEMY_SIDE_LENGTH)
end