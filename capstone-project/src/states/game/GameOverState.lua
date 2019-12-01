--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Game Over State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state that the user sees when the game is over
]]

GameOverState = Class{__includes = BaseState}

--[[ 
    Game Over State constructor function 
        
    @return void
]]
function GameOverState:init()
    self.totalScore = 0
end

--[[
    The enter function for the GameOverState
    Called when state is first entered
    Sets the total score of the game
    and the final level for the player to see

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function GameOverState:enter(params)
  if params then
    self.totalScore = params.totalScore
    LEVEL_NUMBER = params.levelNumber
  end
end

--[[
    The update function for the GameOverState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        LEVEL_NUMBER = 1
        gStateMachine:change('next-level-countdown')
    end
end

--[[
    The render function on this state.
    Renders the level, total Score and Game Over Text
    
    @return void
]]
function GameOverState:render()
    -- [[ Render the background image ]]
    love.graphics.draw(gTextures['startEnd'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['startEnd']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['startEnd']:getHeight())

    -- [[ Render the Total Score ]]
    love.graphics.setFont(gFonts['mediumSmallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Score: ' ..tostring(self.totalScore), 1, VIRTUAL_HEIGHT / 2 - 60 , VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Score: ' ..tostring(self.totalScore), 0, VIRTUAL_HEIGHT / 2 - 62, VIRTUAL_WIDTH, 'center')

    -- [[ Render the Game Over Text ]]
    love.graphics.setFont(gFonts['mediumFlappy'])
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("Game Over", 1, VIRTUAL_HEIGHT / 2 - 23, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(77, 162, 171, 255)
    love.graphics.printf("Game Over", 0, VIRTUAL_HEIGHT / 2 - 25, VIRTUAL_WIDTH, 'center')
    
    -- [[ Render the Level Number ]]
    love.graphics.setFont(gFonts['mediumSmallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Level: ' ..tostring(LEVEL_NUMBER), 1, VIRTUAL_HEIGHT - 80, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Level: ' ..tostring(LEVEL_NUMBER), 0, VIRTUAL_HEIGHT - 82, VIRTUAL_WIDTH, 'center')

    -- [[ Render User Directions ]]
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Press Enter to Play Again', 1, VIRTUAL_HEIGHT - 42, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter to Play Again', 0, VIRTUAL_HEIGHT - 44, VIRTUAL_WIDTH, 'center')
end
