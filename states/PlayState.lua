PlayState = Class{__includes = BaseState}

local shield = love.graphics.newImage('imgs/Shield.png')
local shieldBroken = love.graphics.newImage('imgs/ShieldBroken.png')

local SPAWN_TIME = 3
local MAX_ENEMIES = 10
local ENEMY_SPEED = 400

function PlayState:init()
    self.player = Player()

    self.enemies = {}
    self.numberOfEnemies = 0
    
    self.spawnTimer = 0
end

function PlayState:enter(params)
    self.difficulty = params.difficulty
    self.difficulty = (self.difficulty * 0.2) + 0.6
end

function PlayState:update(dt)

    -- check if a shot has hit an enemy
    for _, shot in pairs(self.player.shots) do
        for k, enemy in pairs(self.enemies) do
            if shot:collides(enemy) then
                enemy.remove = true
            end
        end
    end

    -- check if an enemy has hit the player
    for k, enemy in pairs(self.enemies) do
        if self.player:collides(enemy) then
            self.player:getHit()
        end
    end

    -- remove enemies that must be removed
    for k, enemy in pairs(self.enemies) do
        if enemy.remove then
            table.remove(self.enemies, k)
        end
    end

    -- update enemies and count them
    self.numberOfEnemies = 0
    for k, enemy in pairs(self.enemies) do
        self.numberOfEnemies = self.numberOfEnemies + 1
        enemy:update(dt)
    end


    self.player:update(dt)

    self:spawner(dt)
end

function PlayState:spawner(dt)
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer >= SPAWN_TIME then
        self.spawnTimer = 0
        if self.numberOfEnemies <= MAX_ENEMIES then
            table.insert(self.enemies, self.spawnEnemy())
        end
    end
end

function PlayState:spawnEnemy()
    local xE = 0
    local yE = 0
    local dxE = 0
    local dyE = 0

    local extraDirectionMod = 0.5
    side = {
        [1] = function () 
            xE = - ENEMY_SIDE_LENGTH
            yE = math.random(0 + ENEMY_SIDE_LENGTH, VIRTUAL_HEIGHT - ENEMY_SIDE_LENGTH)
            dxE = ENEMY_SPEED + (math.random(-10, 10))
            dyE = math.random(-ENEMY_SPEED, ENEMY_SPEED) * extraDirectionMod
        end,
        [2] = function ()
            xE = VIRTUAL_WIDTH + ENEMY_SIDE_LENGTH
            yE = math.random(0 + ENEMY_SIDE_LENGTH, VIRTUAL_HEIGHT - ENEMY_SIDE_LENGTH)
            dxE = -ENEMY_SPEED + (math.random(-10, 10))
            dyE = math.random(-ENEMY_SPEED, ENEMY_SPEED) * extraDirectionMod
        end,
        [3] = function ()
            xE = math.random(0 + ENEMY_SIDE_LENGTH, VIRTUAL_WIDTH - ENEMY_SIDE_LENGTH)
            yE = - ENEMY_SIDE_LENGTH
            dxE = math.random(-ENEMY_SPEED, ENEMY_SPEED) * extraDirectionMod
            dyE = ENEMY_SPEED + (math.random(-10, 10))
        end,
        [4] = function ()
            xE = math.random(0 + ENEMY_SIDE_LENGTH, VIRTUAL_WIDTH - ENEMY_SIDE_LENGTH)
            yE = VIRTUAL_HEIGHT + ENEMY_SIDE_LENGTH
            dxE = math.random(-ENEMY_SPEED, ENEMY_SPEED) * extraDirectionMod
            dyE = -ENEMY_SPEED + (math.random(-10, 10))
        end
    }

    side[math.random(4)]()

    return Enemy(xE, yE, dxE, dyE)

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