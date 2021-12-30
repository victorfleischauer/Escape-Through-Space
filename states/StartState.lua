StartState = Class{__includes = BaseState}

local DISTANCE_BETWEEN_OPTIONS = 20

function StartState:init()
    self.selected = 1
    self.selectedOptions = false

    self.volume = math.floor(love.audio.getVolume() * 100)
    self.hasPlayedMusic = false

    select = {
        [1] = function ()
            if not self.selectedOptions then
                gStateMachine:change('play')
            end
        end,
        
        [2] = function () 
            if not self.selectedOptions then
               self.selectedOptions = true
            end
        end,

        [3] = function ()
            if not self.selectedOptions then
                love.event.quit()
            else
                self.selectedOptions = false
            end
        end
    }
end

function StartState:exit()
    sounds['menu']:stop()
end

function StartState:update(dt)

    if not self.hasPlayedMusic then
        if love.audio.getActiveSourceCount() < 1 then
            sounds['menu']:play()
        end
    end

    -- control selected action with arrow keys
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        sounds['select']:play()
        self.selected = self.selected - 1
    end
    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        sounds['select']:play()
        self.selected = self.selected + 1
    end

    self.selected = (self.selected < 1 and 3 or (self.selected > 3 and 1 or self.selected))

    if self.selectedOptions then
        if self.selected == 1 then
            if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
                if not (gDifficulty <= 1) then
                    gDifficulty = gDifficulty - 1
                end
            elseif love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
                if not (gDifficulty >= 3) then
                    gDifficulty = gDifficulty + 1
                end
            end

        elseif self.selected == 2 then
            if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
                if not (self.volume <= 0) then
                    self.volume = self.volume - 10
                end
            elseif love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
                if not (self.volume >= 100) then
                    self.volume = self.volume + 10
                end
            end

            love.audio.setVolume(self.volume / 100)
        end
    end

    if love.keyboard.wasPressed('return') then
        sounds['selected']:play()
        select[self.selected]()
    end
end

function StartState:render()

    love.graphics.setFont(titleFont)
    love.graphics.printf('Escape Through Space', 0, 30, VIRTUAL_WIDTH, 'center')

    positionOfMenu = 120
    
    love.graphics.setFont(menuFont)

    if self.selectedOptions then
        if self.selected == 1 then
            love.graphics.setColor(1, 1, 0, 1)
            love.graphics.printf((gDifficulty == 1 and 'Easy' or (gDifficulty == 2 and 'Medium' or 'Hard')), 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

        elseif self.selected == 2 then
            love.graphics.setColor(1, 1, 0, 1)
            love.graphics.printf(tostring(self.volume), 0, positionOfMenu, VIRTUAL_WIDTH, 'center')
        end
    end

    positionOfMenu = positionOfMenu + DISTANCE_BETWEEN_OPTIONS

    love.graphics.setColor(1, 1, (self.selected == 1 and 0 or 1), 1)
    love.graphics.printf((self.selectedOptions == false and 'Play' or 'Difficulty'), 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

    positionOfMenu = positionOfMenu + DISTANCE_BETWEEN_OPTIONS

    love.graphics.setColor(1, 1, (self.selected == 2 and 0 or 1), 1)
    love.graphics.printf(self.selectedOptions == false and 'Options' or 'Volume', 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

    positionOfMenu = positionOfMenu + DISTANCE_BETWEEN_OPTIONS

    love.graphics.setColor(1, 1, (self.selected == 3 and 0 or 1), 1)
    love.graphics.printf(self.selectedOptions == false and 'Exit game' or 'Back to menu', 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

end