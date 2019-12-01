--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Player Swing Hit State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the player is hitting an ememy close by (swinging its arms/ legs)
    Hitbox creation help from Harvard GD50 Class - Colton Ogden
]]

PlayerSwingHitState = Class{__includes = BaseState}

--[[
    @var string Used to store the player's previous state before entering any swing-hit state
]]
PLAYER_PREVIOUS_STATE = ''

--[[
    @const int The amount to add to the player score if he hits an ememy
]]
PLAYER_HIT_ENEMY_SCORE = 5

--[[
    The PlayerSwingState constructor function

    @player  Player The player object that represents the player in the level

    @return void
]]
function PlayerSwingHitState:init(player)
    self.player = player
    self.playerPreviousState = self.player.state
    self.player.state = 'swing-hit'

    --[[ Create hitbox based on where the player is and facing ]]
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 10
        hitboxHeight = 20
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 10
        hitboxHeight = 20
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    end

    --[[ Separate hitbox for the player's swinging object; Will only be active during this state ]]
    self.Hitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('hit')
end

--[[
    The enter function for the PlayerSwingHitState
    Called when state is first entered

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function PlayerSwingHitState:enter(params)

    --[[ Restart swing sound for rapid swinging ]]
    gSounds['sword']:stop()
    gSounds['sword']:play()

    --[[ Restart swinging animation ]]
    self.player.currentAnimation:refresh()
end

--[[
    The update function for the PlayerSwingHitState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayerSwingHitState:update(dt)

    --[[ Check if hitbox collides with any entities in the level ]]
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.Hitbox) then
            gSounds['hit-enemy']:play()
            self.player.score = self.player.score + PLAYER_HIT_ENEMY_SCORE
            self.player.totalScore = self.player.totalScore + PLAYER_HIT_ENEMY_SCORE
            table.remove(self.player.level.entities, k)
        end
    end

    --[[ Check for object collisions when in this state also ]]
    self.player:checkObjectCollisions()

    --[[ Save the previous state or previous state before entering the swing hit state (so not an infinite loop) ]]
    if self.playerPreviousState == 'jump' then self.playerPreviousState = 'falling' end
    if self.playerPreviousState ~= 'swing-hit' then PLAYER_PREVIOUS_STATE = self.playerPreviousState end

    --[[ If the player fully elapsed through one cycle of animation, change back to the player's previous state ]]
    --[[ This logic prevents the previous state from also being the hit state so we don't enter an infinite loop ]]
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        if self.playerPreviousState == 'swing-hit' then
            self.player:changeState(PLAYER_PREVIOUS_STATE)
        else
            self.player:changeState(self.playerPreviousState)
        end
    end

    --[[ Allow the player to change into this state afresh if he swings within it, rapid swinging ]]
    if love.keyboard.wasPressed('lshift') or love.keyboard.wasPressed('rshift') then
        self.player:changeState('swing-hit')
    end
end
