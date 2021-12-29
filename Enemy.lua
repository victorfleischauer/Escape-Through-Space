Enemy = Class{}

-- local love.graphics.newImage('imgs/Enemy.png')

ENEMY_SIDE_LENGTH = 16

function Enemy:init(x, y, speedX, speedY)
    self.x = x
    self.y = y

    self.dx = speedX
    self.dy = speedY
end

function Enemy:update(dt)
    
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

end

function Enemy:render()
    love.graphics.rectangle('fill', self.x, self.y, ENEMY_SIDE_LENGTH, ENEMY_SIDE_LENGTH)
end