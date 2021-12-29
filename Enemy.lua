Enemy = Class{}

-- local love.graphics.newImage('imgs/Enemy.png')

ENEMY_SIDE_LENGTH = 32

function Enemy:init(x, y, speedX, speedY)
    self.x = x
    self.y = y

    self.dx = speedX
    self.dy = speedY

    self.numberOfBounces = 4
    self.hasEnteredFrame = false
    self.hasBouncedEnough = false
end

function Enemy:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if not self.hasEnteredFrame then
        if self.x > 0 and self.y > 0 and
        self.x < VIRTUAL_WIDTH - ENEMY_SIDE_LENGTH and
        self.y < VIRTUAL_HEIGHT - ENEMY_SIDE_LENGTH then 
            self.hasEnteredFrame = true
        else
            if self.x < -ENEMY_SIDE_LENGTH then
                self.x = -ENEMY_SIDE_LENGTH
                self.dx = -self.dx
            elseif self.x > VIRTUAL_WIDTH then
                self.x = VIRTUAL_WIDTH
                self.dx = -self.dx
            elseif self.y < -ENEMY_SIDE_LENGTH then
                self.y = -ENEMY_SIDE_LENGTH
                self.dy = -self.dy
            elseif self.y > VIRTUAL_HEIGHT then
                self.y = VIRTUAL_HEIGHT
                self.dy = -self.dy
            end
        end
    elseif not self.hasBouncedEnough then
        if self.x < 0 then
            self.x = 0
            self.dx = -self.dx
            self.numberOfBounces = self.numberOfBounces - 1
        elseif self.x > VIRTUAL_WIDTH - ENEMY_SIDE_LENGTH then
            self.x = VIRTUAL_WIDTH - ENEMY_SIDE_LENGTH
            self.dx = -self.dx
            self.numberOfBounces = self.numberOfBounces - 1
        elseif self.y < 0 then
            self.y = 0
            self.dy = -self.dy
            self.numberOfBounces = self.numberOfBounces - 1
        elseif self.y > VIRTUAL_HEIGHT - ENEMY_SIDE_LENGTH then
            self.y = VIRTUAL_HEIGHT - ENEMY_SIDE_LENGTH
            self.dy = -self.dy
            self.numberOfBounces = self.numberOfBounces - 1
        end

        if self.numberOfBounces <= 0 then
            self.hasBouncedEnough = true
        end
    end

    if self.x < -ENEMY_SIDE_LENGTH * 2 or self.y < -ENEMY_SIDE_LENGTH * 2 or
        self.x > VIRTUAL_WIDTH + ENEMY_SIDE_LENGTH * 2 or
        self.y > VIRTUAL_HEIGHT + ENEMY_SIDE_LENGTH * 2 then
            self.remove = true
    end
end

function Enemy:render()
    love.graphics.rectangle('fill', self.x, self.y, ENEMY_SIDE_LENGTH, ENEMY_SIDE_LENGTH)
end