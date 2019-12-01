--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Play State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This is the state where the user can play. Controls everything related to the game
]]

PlayState = Class{__includes = BaseState}

--[[ 
    Play State constructor function 
    Sets intitial level parameters, timer, and player
    
    @return void
]]
function PlayState:init()

    --[[ Initialize intial level variables ]]
    self.levelTimer = math.max(122 - (LEVEL_NUMBER * 2), 30)
    self.currentLevelScoreLimit = 50 + (LEVEL_NUMBER * 10)
    self.level = Level(VIRTUAL_WIDTH, LEVEL_MAKER_HEIGHT, self.levelTimer):generate()
    self.gravity = 6
    self.minute = math.floor(self.levelTimer / 60)
    self.seconds = self.levelTimer % 60

    --[[ Flags so corresponding functions don't get called over and over in update function ]]
    self.seaTurtleSpawned = false
    self.enemiesSpawned = false
    self.dynamicEnemiesSpawned = false
    self.fallingGameObjectsTriggered = false
    self.timerTriggered = false

    -- [[ Instantiate Player for the level ]]
    self.player = Player({
        x = math.random(VIRTUAL_WIDTH - 2), 
        y = 0,
        width = 20, 
        height = 36,
        texture = 'diver',
        health = 8,
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        direction = 'right',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravity) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravity) end,
            ['power-up'] = function() return PlayerPowerUpState(self.player, self.gravity) end,
            ['swing-hit'] = function() return PlayerSwingHitState(self.player) end
        },
        map = self.level.tileMap,
        level = self.level
    })

    self.player:changeState('falling')
end

--[[
    The enter function for the PlayState
    Called when state is first entered
    Sets the score and total score and health in between levels
    Also used to set the current player/ other params when coming from pause state

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function PlayState:enter(params)
    if params then
        if params.levelTimer then
            LEVEL_NUMBER = params.levelNumber
            self.player = params.player
            self.levelTimer = params.levelTimer
            self.level = params.player.level
            self.currentLevelScoreLimit = params.currentLevelScoreLimit
            if self.levelTimer <= 40 and self.levelTimer >=5 then
                self.seaTurtleSpawned = true
            end
            self.enemiesSpawned = true
        else
            self.player.score = 0
            self.player.totalScore = params.totalScore
            LEVEL_NUMBER = params.levelNumber
            self.player.health = params.health
        end
    end
end

--[[
    The update function for the PauseState. Called every dt
    If enter is pressed, un-pause the game

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayState:update(dt)
    Timer.update(dt)

    --[[ Remove any nils from pickups, etc. ]]
    self.level:clear()

    -- [[ Update the player and level ]]
    self.player:update(dt)
    self.level:update(dt)

    -- [[ Constrain player X no matter which state, player won't go outside of the game boundaries ]]
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > VIRTUAL_WIDTH - self.player.width then
        self.player.x = VIRTUAL_WIDTH - self.player.width
    end

    --[[ Trigger the timer api to update the timer every second ]]
    if not self.timerTriggered then
        Timer.every(2, function()
            self.levelTimer = self.levelTimer - 1
            self.seconds = self.levelTimer % 60
            self.minute = math.floor(self.levelTimer / 60)

            --[[ Play warning sound on timer if we get to 5 seconds or less ]]
            if self.levelTimer <= 5 then
                gSounds['clock']:play()
            end
        end)
        self.timerTriggered = true
    end

    -- [[ Call functions to render game objects and entities ]]
    if not self.enemiesSpawned then
        self.level:spawnEnemies(self.player)
        self.enemiesSpawned = true
    end

    if not self.dynamicEnemiesSpawned then
        self.level:dynamicallySpawnEnemies(self.player)
        self.dynamicEnemiesSpawned = true
    end

    if not self.seaTurtleSpawned and self.levelTimer <= 40 and self.levelTimer >= 5 and math.random(3000) == 1 then 
        self.level:spawnSeaTurtle(self.player)
        self.seaTurtleSpawned = true
    end

    if not self.fallingGameObjectsTriggered then
        self.level:generateFallingGameObjects(self.player)
        self.fallingGameObjectsTriggered = true
    end

    --[[ If the shift keys are pressed, player is able to hit enemies if near to them ]]
    if love.keyboard.wasPressed('lshift') or love.keyboard.wasPressed('rshift') then
        self.player:changeState('swing-hit')
    end

    --[[ If enter key is pressed, pause the game ]]
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('pause',{
            player = self.player,
            levelNumber = LEVEL_NUMBER,
            levelTimer = self.levelTimer,
            currentLevelScoreLimit = self.currentLevelScoreLimit
        })
      end

    --[[ If the timer runs out transition to the game over state ]]
    if self.levelTimer <= 0 then
        Timer.clear()
        gStateMachine:change('game-over', {
            totalScore = self.player.totalScore,
            levelNumber = LEVEL_NUMBER
        })
    end

    --[[ If player reaches a certain score, transition to the next level ]]
    if self.player.score >= self.currentLevelScoreLimit then
        Timer.clear()
        LEVEL_NUMBER = LEVEL_NUMBER + 1
        gStateMachine:change('next-level-countdown', {
            player = self.player,
            levelNumber = LEVEL_NUMBER
        })
    end

    --[[ If player health runs out, transition to game over state ]]
    if self.player.health == 0 then
        Timer.clear()
        gSounds['death']:play()
        gStateMachine:change('game-over', {
          totalScore = self.player.totalScore,
          levelNumber = LEVEL_NUMBER
        })
    end
end

--[[
    The render function on this state.
    Renders health, level, timer etc.
    Calls render on everything involved with the play state
    
    @return void
]]
function PlayState:render()
    love.graphics.push()

    --[[ Render the background ]]
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())
    
    -- [[ Render the level and player ]]
    self.level:render()
    self.player:render()
    love.graphics.pop()

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
