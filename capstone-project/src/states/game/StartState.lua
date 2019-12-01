--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Start State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This is the state that the user sees at the start of the game before entering the play state
]]

StartState = Class{__includes = BaseState}

--[[
    The update function for the StartState. Called every dt
    If enter is pressed, start the game

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('next-level-countdown')
    end
end

--[[
    The render function on this state.
    Renders title and player directions
    
    @return void
]]
function StartState:render()
    
    --[[ Render the background ]]
    love.graphics.draw(gTextures['startEnd'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['startEnd']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['startEnd']:getHeight())

    --[[ Render the title ]]
    love.graphics.setFont(gFonts['mediumFlappy'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('The Great', 2, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(77, 162, 171, 255)
    love.graphics.printf('The Great', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Ocean Clean Up', 2, VIRTUAL_HEIGHT / 2 + 8, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(77, 162, 171, 255)
    love.graphics.printf('Ocean Clean Up', 0, VIRTUAL_HEIGHT / 2 + 6, VIRTUAL_WIDTH, 'center')

    --[[ Render the player directions ]]
    love.graphics.setFont(gFonts['mediumSmallFlappy'])
    love.graphics.setColor(34, 34, 34, 255)
    love.graphics.printf('Press Enter to Begin', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter to Begin', 0, VIRTUAL_HEIGHT / 2 + 68, VIRTUAL_WIDTH - 2, 'center')
end
