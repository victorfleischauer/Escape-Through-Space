Player = Class{}

local SPEED = 2
local MAX_SPEED = 4

function Player:init()
    self.naveBase = love.graphics.newImage('imgs/Nave.png')

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

        
    self.aUP = false
    self.aDO = false
    self.aLE = false
    self.aRI = false
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

end

function Player:render()
    love.graphics.draw(self.naveBase, self.x, self.y)
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