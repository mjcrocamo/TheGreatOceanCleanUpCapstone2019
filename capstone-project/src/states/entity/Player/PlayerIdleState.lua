--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Player Idle State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
     This represents the state where the player is idle
]]

PlayerIdleState = Class{__includes = BaseState}

--[[
    The PlayerIdleState constructor function

    @player Player The player object that represents the player in the level

    @return void
]]
function PlayerIdleState:init(player)
    self.player = player
    self.player.state = 'idle'
    self.player:changeAnimation('idle')
end

--[[
    The update function for the PlayerIdleState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayerIdleState:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    --[[ Check object and entity collisions ]]
    self.player:checkObjectCollisions()
    self.player:checkEntityCollisions()
end
