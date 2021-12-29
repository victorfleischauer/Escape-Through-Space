PlayState = Class{__includes = BaseState}

local shield = love.graphics.newImage('imgs/Shield.png')
local shieldBroken = love.graphics.newImage('imgs/ShieldBroken.png')

function PlayState:init()
    self.player = Player()

    self.enemies = {}
    table.insert(self.enemies, Enemy(100, 100))
end

function PlayState:update(dt)

    
    for _, shot in pairs(self.player.shots) do
        for k, enemy in pairs(self.enemies) do
            if shot:collides(enemy) then
                enemy.remove = true
            end
        end
    end

    for k, enemy in pairs(self.enemies) do
        if self.player:collides(enemy) then
            self.player:getHit()
        end
    end

    for k, enemy in pairs(self.enemies) do
        enemy:update(dt)
    end

    for k, enemy in pairs(self.enemies) do
        if enemy.remove then
            table.remove(self.enemies, k)
        end
    end

    self.player:update(dt)
end

function PlayState:render()
    self.player:render()
    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end

    love.graphics.draw(shieldBroken, 4, 4)
    love.graphics.draw(shieldBroken, 24, 4)
    love.graphics.draw(shieldBroken, 44, 4)

    for i = 4, ((self.player.hp - 1) * 20) + 4, 20 do
        love.graphics.draw(shield, i, 4)
    end
end