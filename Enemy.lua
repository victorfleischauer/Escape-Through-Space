Enemy = Class{}

-- local love.graphics.newImage('imgs/Enemy.png')

ENEMY_SIDE_LENGTH = 32

function Enemy:init(x, y, speedX, speedY)
    self.imageEnemy = love.graphics.newImage('imgs/enemy.png')
    self.flare = love.graphics.newImage('imgs/flare.png')

    self.explosion1 = love.graphics.newImage('imgs/Explosion/Explosion1.png')
    self.explosion2 = love.graphics.newImage('imgs/Explosion/Explosion2.png')
    self.explosion3 = love.graphics.newImage('imgs/Explosion/Explosion3.png')
    self.explosion4 = love.graphics.newImage('imgs/Explosion/Explosion4.png')
    self.explosion5 = love.graphics.newImage('imgs/Explosion/Explosion5.png')
    self.explosion6 = love.graphics.newImage('imgs/Explosion/Explosion6.png')
    self.explosion7 = love.graphics.newImage('imgs/Explosion/Explosion7.png')

    self.explosionTimer = 0
    self.framesLeft = 11
    self.exploding = false

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

    if not self.exploding then
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
        end
        if self.numberOfBounces <= 0 then
            self.hasBouncedEnough = true
        end
    else
        self.explosionTimer = self.explosionTimer + dt
        if self.explosionTimer > 0.03 then
            self.explosionTimer = self.explosionTimer % 0.03
            self.framesLeft = self.framesLeft - 1
        end
        if self.framesLeft <= 0 then
            self.remove = true
        end
    end

    if self.x < -ENEMY_SIDE_LENGTH * 2 or self.y < -ENEMY_SIDE_LENGTH * 2 or
        self.x > VIRTUAL_WIDTH + ENEMY_SIDE_LENGTH * 2 or
        self.y > VIRTUAL_HEIGHT + ENEMY_SIDE_LENGTH * 2 then
            self.remove = true
    end
end

function Enemy:render()
    if self.framesLeft > 4 then
        love.graphics.draw(self.imageEnemy, self.x, self.y)
    end

    if self.hasBouncedEnough and not self.exploding then
        love.graphics.draw(self.flare, self.x - 5, self.y - 5)
        love.graphics.draw(self.flare, self.x - 5 + ENEMY_SIDE_LENGTH, self.y - 5)
        love.graphics.draw(self.flare, self.x - 5, self.y - 5 + ENEMY_SIDE_LENGTH)
        love.graphics.draw(self.flare, self.x - 5 + ENEMY_SIDE_LENGTH, self.y - 5 + ENEMY_SIDE_LENGTH)
    end

    local frames = {
        [10] = self.explosion1,
        [9] = self.explosion2,
        [8] = self.explosion3,
        [7] = self.explosion4,
        [6] = self.explosion5,
        [5] = self.explosion5,
        [4] = self.explosion6,
        [3] = self.explosion6,
        [2] = self.explosion7,
        [1] = self.explosion7,
        [0] = self.explosion7
    }

    if self.exploding and self.framesLeft <= 10 then
        love.graphics.draw(frames[self.framesLeft], self.x, self.y)
    end
end