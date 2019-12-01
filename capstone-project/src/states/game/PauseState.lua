--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Pause State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    A simple state used to display the a pause in the game.
    Nothing is able to be played and the score remains the same
    until player un-pauses game and transfers into play state.
]]

PauseState = Class{__includes = BaseState}

--[[ 
    Pause State constructor function 
    
    @return void
]]
function PauseState:init()
  self.levelNumber = LEVEL_NUMBER
  self.levelTimer = 30
  self.minute = 0
  self.seconds = 30
  self.player = Player(ENTITY_DEFS['player'], 0, 0)
  self.currentLevelScoreLimit = 0
end


--[[
    The enter function for the PauseState
    Called when state is first entered
    Saves the current player, level timer, and level number

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function PauseState:enter(params)
    Timer.clear()
    gSounds['game-music']:stop()
    gSounds['pause']:play()
    self.player = params.player
    self.levelNumber = LEVEL_NUMBER
    self.levelTimer = params.levelTimer
    self.minute = math.floor(params.levelTimer / 60)
    self.seconds = params.levelTimer % 60
    self.currentLevelScoreLimit = params.currentLevelScoreLimit
end

--[[
    The update function for the PauseState. Called every dt
    If enter is pressed, un-pause the game

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PauseState:update(dt)
    -- go back to play if p is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Timer.clear()
        gStateMachine:change('play', {
          player = self.player,
          levelNumber = LEVEL_NUMBER,
          levelTimer = self.levelTimer,
          currentLevelScoreLimit = self.currentLevelScoreLimit
        })
    end
end

--[[
    The render function on this state.
    Renders the level number, player scores, current timer and health left
    
    @return void
]]
function PauseState:render()

  --[[ Render the background ]]
  love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    --[[ Render pause text in the middle of the screen ]]
    love.graphics.setFont(gFonts['mediumSmallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Game Paused', VIRTUAL_WIDTH / 2 - 86, VIRTUAL_HEIGHT/ 2 - 25)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Game Paused', VIRTUAL_WIDTH / 2 - 85, VIRTUAL_HEIGHT/ 2 - 26)

    -- [[ Render pause symbol ]]
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2 + 1) - 8, VIRTUAL_HEIGHT / 2 + 11, 7, 26)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) - 8, VIRTUAL_HEIGHT / 2 + 10, 7, 26)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2 + 1) + 8, VIRTUAL_HEIGHT / 2 + 11, 7, 26)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) + 8, VIRTUAL_HEIGHT / 2 + 10, 7, 26)


     --[[ Render scores and level ]]
     love.graphics.setFont(gFonts['smallFlappy'])
     love.graphics.setColor(0, 0, 0, 255)
     love.graphics.print('Overall Score: '..tostring(self.player.totalScore), 5, 5)
     love.graphics.setColor(255, 255, 255, 255)
     love.graphics.print('Overall Score: '..tostring(self.player.totalScore), 4, 4)
 
    --[[ Render level timer ]]
    if self.seconds >= 10 then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print('Time to Go: ' ..tostring(self.minute) ..':' ..tostring(self.seconds), VIRTUAL_WIDTH/ 2 - 38, 5)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print('Time to Go: ' ..tostring(self.minute) ..':' ..tostring(self.seconds), VIRTUAL_WIDTH/ 2 - 39, 4)
    else 
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print('Time to Go: ' ..tostring(self.minute) ..':0' ..tostring(self.seconds), VIRTUAL_WIDTH/ 2 - 38, 5)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print('Time to Go: ' ..tostring(self.minute) ..':0' ..tostring(self.seconds), VIRTUAL_WIDTH/ 2 - 39, 4)
    end
 
     love.graphics.setColor(0, 0, 0, 255)
     love.graphics.print('Level: ' ..tostring(LEVEL_NUMBER), VIRTUAL_WIDTH - 63, 5)
     love.graphics.setColor(255, 255, 255, 255)
     love.graphics.print('Level: ' ..tostring(LEVEL_NUMBER), VIRTUAL_WIDTH - 64, 4)
 
     love.graphics.setFont(gFonts['smallFlappy'])
     love.graphics.setColor(0, 0, 0, 255)
     love.graphics.print('Level Score: '..tostring(self.player.score), 5, 20)
     love.graphics.setColor(255, 255, 255, 255)
     love.graphics.print('Level Score: '..tostring(self.player.score), 4, 19)
 
     love.graphics.setFont(gFonts['smallFlappy'])
     love.graphics.setColor(0, 0, 0, 255)
     love.graphics.print('Level Limit: '..tostring(self.currentLevelScoreLimit), 5, 36)
     love.graphics.setColor(255, 255, 255, 255)
     love.graphics.print('Level Limit: '..tostring(self.currentLevelScoreLimit), 4, 35)

     -- [[ Render hearts (health) ]]
     local health = self.player.health
     local heartFrame = 1
 
     for i = 1, 4 do
         if health > 1 then
             heartFrame = 5
         elseif health == 1 then
             heartFrame = 3
         else
             heartFrame = 1
         end
 
         love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
             (i - 1) * (TILE_SIZE + 1) + (VIRTUAL_WIDTH - (TILE_SIZE * 4) - 10), 20)
 
         health = health - 2
     end
end

--[[
    The state's exit funciton. Method called on state exit
    Turns on the music again

    @return void
]]
function PauseState:exit()
  gSounds['pause']:play()
  gSounds['game-music']:play()
end
