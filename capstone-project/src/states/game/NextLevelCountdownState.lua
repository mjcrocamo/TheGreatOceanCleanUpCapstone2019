--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Next Level Countdown State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    Counts down visually on the screen (3, 2, 1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.

    Help from Harvard GD50 Class - Colton Ogden
]]

NextLevelCountdownState = Class{__includes = BaseState}

--[[
    @const int The amount set so it takes 1 second to count down each time
]]
COUNTDOWN_TIME = 0.75

--[[ 
    Next Level Countdown State constructor function 
    
    @return void
]]
function NextLevelCountdownState:init()
    self.count = 3
    self.timer = 0
    self.player = Player(ENTITY_DEFS['player'], 0, 0)
    self.levelNumber = LEVEL_NUMBER
    self.currentLevelScoreLimit = 50 + (LEVEL_NUMBER * 10)
    self.levelTimer = math.max(122 - (LEVEL_NUMBER * 2), 30)
    self.minute = math.floor(self.levelTimer / 60)
    self.seconds = self.levelTimer % 60
end

--[[
    The enter function for the NextLevelCountdownState
    Called when state is first entered
    Sets the current player to be used in the next level as well as the level number

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function NextLevelCountdownState:enter(params)
  Timer.clear()
  self.levelNumber = LEVEL_NUMBER
  if params then
    self.player = params.player
  else 
    self.player.health = 8
  end
end

--[[
    The update function for the NextLevelCountdownState. Called every dt
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function NextLevelCountdownState:update(dt)
    self.timer = self.timer + dt

    --[[ Loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
         and decrement the counter once we've gone past the countdown time ]]
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- [[ When 0 is reached, enter the PlayState ]]
        if self.count == 0 then
          if LEVEL_NUMBER > 1 then
            gStateMachine:change('play', {
              score = self.player.score,
              totalScore = self.player.totalScore,
              levelNumber = LEVEL_NUMBER,
              health = self.player.health
            })
          else
            gStateMachine:change('play')
          end
        end
    end
end

--[[
    The render function on this state.
    Renders the next level and countdown
    
    @return void
]]
function NextLevelCountdownState:render()

  -- [[ Render the background ]]
  love.graphics.draw(gTextures['background'], 0, 0, 0, 
  VIRTUAL_WIDTH / gTextures['background']:getWidth(),
  VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    --[[ Render pause text in the middle of the screen ]]
    love.graphics.setFont(gFonts['mediumSmallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Begin Level: '..tostring(LEVEL_NUMBER), VIRTUAL_WIDTH / 2 - 94, VIRTUAL_HEIGHT/ 2 - 25)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Begin Level: '..tostring(LEVEL_NUMBER), VIRTUAL_WIDTH / 2 - 93, VIRTUAL_HEIGHT/ 2 - 26)

    --[[ Render the count in the middle of the screen ]]
    love.graphics.setFont(gFonts['mediumFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf(tostring(self.count), 2, 120, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')

     --[[ Render scores and level ]]
    love.graphics.setFont(gFonts['smallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Overall Score: '..tostring(self.player.totalScore), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Overall Score: '..tostring(self.player.totalScore), 4, 4)
 
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Level: ' ..tostring(LEVEL_NUMBER), VIRTUAL_WIDTH - 63, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Level: ' ..tostring(LEVEL_NUMBER), VIRTUAL_WIDTH - 64, 4)
 
    love.graphics.setFont(gFonts['smallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Level Score: 0', 5, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Level Score: 0', 4, 19)
 
    love.graphics.setFont(gFonts['smallFlappy'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print('Level Limit: '..tostring(self.currentLevelScoreLimit), 5, 36)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Level Limit: '..tostring(self.currentLevelScoreLimit), 4, 35)

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

    @return void
]]
function NextLevelCountdownState:exit()
    Timer.clear()
end