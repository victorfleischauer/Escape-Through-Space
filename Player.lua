Player = Class{}

function Player:init()
    self.naveBase = love.graphics.newImage('imgs/Nave.png')

    self.x = 0
    self.y = 0

    self.width = self.naveBase:getWidth()
    self.height = self.naveBase:getHeight()

    self.dx = 0
    self.dy = 0
end

function Player:render()
    love.graphics.draw(self.naveBase, self.x, self.y)
end