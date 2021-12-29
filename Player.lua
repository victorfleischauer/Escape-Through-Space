Player = Class{}

local FORGIVNESS = 2

local SPEED = 4
local MAX_SPEED = 4
local SHOT_COOLDOWN = 0.5

local RECOVER_TIME = 3

function Player:init()
    self.naveBase = love.graphics.newImage('imgs/Nave.png')
    self.naveCool = love.graphics.newImage('imgs/NaveCool.png')

    self.naveUp = love.graphics.newImage('imgs/NaveUp.png')
    self.naveDo = love.graphics.newImage('imgs/NaveDo.png')
    self.naveLe = love.graphics.newImage('imgs/NaveLe.png')
    self.naveRi = love.graphics.newImage('imgs/NaveRi.png')

    self.width = self.naveBase:getWidth()
    self.height = self.naveBase:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dx = 0
    self.dy = 0

    self.hp = 3
        
    self.aUP = false
    self.aDO = false
    self.aLE = false
    self.aRI = false

    self.canShoot = true
    self.shotTimer = 0

    self.recoverTimer = 0
    self.recovering = false

    self.blink = false

    self.shots = {}
end

function Player:update(dt)
    self.aUP = false
    self.aDO = false
    self.aLE = false
    self.aRI = false

    -- speed control
    if love.keyboard.isDown('w') then
        self.dy = self.dy - SPEED * dt
        self.aUP = true
    end
    if love.keyboard.isDown('s') then
        self.dy = self.dy + SPEED * dt
        self.aDO = true
    end
    if love.keyboard.isDown('d') then
        self.dx = self.dx + SPEED * dt
        self.aRI = true
    end
    if love.keyboard.isDown('a') then
        self.dx = self.dx - SPEED * dt
        self.aLE = true
    end

    -- cap speed
    if self.dx > MAX_SPEED then
        self.dx = MAX_SPEED
    elseif self.dx < -MAX_SPEED then
        self.dx = -MAX_SPEED
    end
    if self.dy > MAX_SPEED then
        self.dy = MAX_SPEED
    elseif self.dy < -MAX_SPEED then
        self.dy = -MAX_SPEED
    end

    -- update position
    self.x = self.x + self.dx
    self.y = self.y + self.dy

    if self.x > VIRTUAL_WIDTH then
        self.x = -self.width
    elseif self.x < -self.width then
        self.x = VIRTUAL_WIDTH
    end
    if self.y > VIRTUAL_HEIGHT then
        self.y = -self.height
    elseif self.y < -self.height then
        self.y = VIRTUAL_HEIGHT
    end

    if self.canShoot then
        self.shotTimer = 0
        if love.keyboard.wasPressed('up') then
            self.canShoot = false
            table.insert(self.shots, Tiro(self.x + 6, self.y, 'Up'))
        elseif love.keyboard.wasPressed('down') then
            self.canShoot = false
            table.insert(self.shots, Tiro(self.x + 6, self.y + 8, 'Down'))
        elseif love.keyboard.wasPressed('left') then
            self.canShoot = false
            table.insert(self.shots, Tiro(self.x + 4, self.y + 6, 'Left'))
        elseif love.keyboard.wasPressed('right') then
            self.canShoot = false
            table.insert(self.shots, Tiro(self.x + 8, self.y + 6, 'Right'))
        end
    else
        self.shotTimer = self.shotTimer + dt
        if self.shotTimer >= SHOT_COOLDOWN then
            self.canShoot = true
        end
    end

    for k,shot in pairs(self.shots) do
        shot:update(dt)
    end

    for k,shot in pairs(self.shots) do
        if shot.remove then
            table.remove(self.shots, k)
        end
    end

    if self.recovering then
        self.recoverTimer = self.recoverTimer + dt

        if self.recoverTimer % 0.25 > 0.125 then
            self.blink = true
        else
            self.blink = false
        end

        if self.recoverTimer >= RECOVER_TIME then
            self.recovering = false
            self.recoverTimer = 0
            self.blink = false
        end
    end
end

function Player:collides(enemy)
    if (self.x) + (self.width - FORGIVNESS) >= enemy.x and self.x + FORGIVNESS <= enemy.x + ENEMY_SIDE_LENGTH then
        if (self.y) + (self.height - FORGIVNESS) >= enemy.y and self.y + FORGIVNESS <= enemy.y + ENEMY_SIDE_LENGTH then
            return true
        end
    end
end

function Player:getHit()
    if not self.recovering then
        self.hp = self.hp - 1

        self.recovering = true
    end
end

function Player:render()
    for k,shot in pairs(self.shots) do
        shot:render()
    end

    if not self.blink then
        if self.canShoot then
        love.graphics.draw(self.naveBase, self.x, self.y)
        else
            love.graphics.draw(self.naveCool, self.x, self.y)
        end
        if self.aUP then
            love.graphics.draw(self.naveDo, self.x, self.y)
        end
        if self.aDO then
            love.graphics.draw(self.naveUp, self.x, self.y)
        end
        if self.aRI then
            love.graphics.draw(self.naveLe, self.x, self.y)
        end
        if self.aLE then
            love.graphics.draw(self.naveRi, self.x, self.y)
        end
    end

end