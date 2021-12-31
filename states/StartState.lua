StartState = Class{__includes = BaseState}

-- distance between each option in the menu
local DISTANCE_BETWEEN_OPTIONS = 20

function StartState:init()

    -- variable to store wich item is highlighted in the menu
    self.selected = 1

    -- is in the options menu?
    self.selectedOptions = false

    -- local volume variable goes from 0 to 100
    self.volume = math.floor(love.audio.getVolume() * 100)
    
    -- has started the menu song?
    self.hasPlayedMusic = false

    -- menu options
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

-- stops the menu song if state changes
function StartState:exit()
    sounds['menu']:stop()
end

function StartState:update(dt)

    if not self.hasPlayedMusic then
        -- checks if there are any other sounds playing
        -- this is to prevent the results song from intersecting with the menu song 
        if love.audio.getActiveSourceCount() < 1 then
            sounds['menu']:play()
        end
    end

    -- control selected action with arrow keys or w and s
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        sounds['select']:play()
        self.selected = self.selected - 1
    end
    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        sounds['select']:play()
        self.selected = self.selected + 1
    end

    -- rotates selection if has reached end
    self.selected = (self.selected < 1 and 3 or (self.selected > 3 and 1 or self.selected))

    -- if is in the options menu
    if self.selectedOptions then
        -- 1 is for difficulty and 2 is for volume
        if self.selected == 1 then
            -- gDifficulty goes from 1 to 3
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

            -- changes back to 0 to 1 scale to update volume
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

    -- changes options displayed based on wich menu the player is
    love.graphics.setColor(1, 1, (self.selected == 1 and 0 or 1), 1)
    love.graphics.printf((self.selectedOptions == false and 'Play' or 'Difficulty'), 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

    positionOfMenu = positionOfMenu + DISTANCE_BETWEEN_OPTIONS

    love.graphics.setColor(1, 1, (self.selected == 2 and 0 or 1), 1)
    love.graphics.printf(self.selectedOptions == false and 'Options' or 'Volume', 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

    positionOfMenu = positionOfMenu + DISTANCE_BETWEEN_OPTIONS

    love.graphics.setColor(1, 1, (self.selected == 3 and 0 or 1), 1)
    love.graphics.printf(self.selectedOptions == false and 'Exit game' or 'Back to menu', 0, positionOfMenu, VIRTUAL_WIDTH, 'center')

end