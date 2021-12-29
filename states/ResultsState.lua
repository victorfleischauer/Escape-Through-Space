ResultsState = Class{__includes = BaseState}

function ResultsState:enter(params)
    self.results = params.results
    self.score = params.score
end

function ResultsState:update(dt)
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function ResultsState:render()
    if self.results == 'timeWin' then
        love.graphics.setFont(titleFont)
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('YOU SURVIVED!', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif self.results == 'timeFail' then
        love.graphics.setFont(titleFont)
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('You died... but you scored:', 0, 30, VIRTUAL_WIDTH, 'center')

        love.graphics.setColor(0,1,0,1)
        love.graphics.printf(tostring(self.score), 0, 90, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(menuFont)
        love.graphics.setColor(1,1,0,1)
        love.graphics.printf('CONTINUE', 0, 200, VIRTUAL_WIDTH, 'center')
    end

end