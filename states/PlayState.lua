PlayState = Class{__includes = BaseState}

local shield = love.graphics.newImage('imgs/Shield.png')
local shieldBroken = love.graphics.newImage('imgs/ShieldBroken.png')

local SPAWN_TIME = 2
local MAX_ENEMIES = 10
local ENEMY_SPEED = 200

local SURVIVAL_GOAL = 30

function PlayState:init()
    self.player = Player()

    self.enemies = {}
    self.numberOfEnemies = 0
    
    self.spawnTimer = 0

    self.survivalTimer = 0

    self.score = 0
end

function PlayState:enter(params)
    self.difficulty = params.difficulty
    self.difficulty = (self.difficulty * 0.25) + 0.5
end

function PlayState:update(dt)

    self.survivalTimer = self.survivalTimer + dt

    if self.survivalTimer >= SURVIVAL_GOAL then
        if self.score == 0 then
            self.score = (self.difficulty <= 0.76 and 1000 or (self.difficulty >= 1.24 and 100000 or 10000))
        else
            self.score = self.score + 1000
        end
        self.score = self.score + 1

        gStateMachine:change('results', {
            results = 'timeWin',
            score = self.score
        })
    end

    -- check if a shot has hit an enemy
    for _, shot in pairs(self.player.shots) do
        for k, enemy in pairs(self.enemies) do
            if shot:collides(enemy) then
                enemy.exploding = true
                self.score = self.score + 100 * self.difficulty
            end
        end
    end

    -- check if an enemy has hit the player
    for k, enemy in pairs(self.enemies) do
        if self.player:collides(enemy) and not (enemy.framesLeft < 7) then
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

    if self.player.death then
        gStateMachine:change('results', {
            results = 'timeFail',
            score = self.score
        })
    end
end

function PlayState:spawner(dt)
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer >= (SPAWN_TIME * (2 - self.difficulty)) then
        self.spawnTimer = 0
        if self.numberOfEnemies <= (MAX_ENEMIES * self.difficulty) then
            local xE = 0
            local yE = 0
            local dxE = 0
            local dyE = 0

            local extraDirectionMod = 0.8
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

            dxE = dxE * self.difficulty
            dyE = dyE * self.difficulty

            table.insert(self.enemies, Enemy(xE, yE, dxE, dyE))
        end
    end
end

function PlayState:render()
    self.player:render()
    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end

    love.graphics.draw(shieldBroken, 4, 8)
    love.graphics.draw(shieldBroken, 24, 8)
    love.graphics.draw(shieldBroken, 44, 8)

    for i = 4, ((self.player.hp - 1) * 20) + 4, 20 do
        love.graphics.draw(shield, i, 8)
    end

    love.graphics.setFont(timerFont)
    local timerRounded = math.floor(self.survivalTimer * 10) / 10
    love.graphics.printf(((timerRounded % 1) ~= 0 and tostring(timerRounded) or (tostring(timerRounded) .. '.0')), 0, 4, VIRTUAL_WIDTH, 'center')

    love.graphics.printf(tostring(self.score), 0, 4, VIRTUAL_WIDTH - 4, 'right')
end