PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()

    self.enemies = {}
    table.insert(self.enemies, Enemy(100, 100))
end

function PlayState:update(dt)

    --[[
    if self.player:collides() then
        -- TODO
    end
    ]]
    
    for _, shot in pairs(self.player.shots) do
        for k, enemy in pairs(self.enemies) do
            if shot:collides(enemy) then
                table.remove(self.enemies, k)
            end
        end
    end

    for k, enemy in pairs(self.enemies) do
        enemy:update(dt)
    end

    self.player:update(dt)
end

function PlayState:render()
    self.player:render()
    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end
end