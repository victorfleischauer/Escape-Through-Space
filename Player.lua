Player = Class{}

function Player:init()
    self.naveBase = love.graphics.newImage('imgs/Nave.png')

    self.width = self.naveBase:getWidth()
    self.height = self.naveBase:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dx = 0
    self.dy = 0
end

function Player:render()
    love.graphics.draw(self.naveBase, self.x, self.y)
end