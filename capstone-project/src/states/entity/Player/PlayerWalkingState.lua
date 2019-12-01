--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Player Walking State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the player is walking
]]
PlayerWalkingState = Class{__includes = BaseState}

--[[
    The PlayerWalkingState constructor function

    @player Player The player object that represents the player in the level

    @return void
]]
function PlayerWalkingState:init(player)
    self.player = player
    self.player.state = 'walking'
    self.player:changeAnimation('walk')
end

--[[
    The update function for the PlayerWalkingState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayerWalkingState:update(dt)

    -- idle if we're not pressing anything at all
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.player:changeState('idle')
    else
        --[[ Look at two tiles below the players feet and check for collisions ]]
        --[[ Help from GD50 Class - Colton Ogden ]]
        local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
        local tileBottomRight = self.player.map:pointToTile(self.player.x - 4 + self.player.width - 1, self.player.y + self.player.height)

        --[[ Temporarily shift player down a pixel to test for game objects beneath ]]
        self.player.y = self.player.y + 1
        local collidedObjects = self.player:checkObjectCollisions()
        self.player.y = self.player.y - 1

        -- [[ Check to see whether there are any tiles beneath the player ]]
        --[[ Help from GD50 Class - Colton Ogden ]]
        if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
            self.player.dy = 0
            self.player:changeState('falling')
        --[[ Else check the left and right collisions ]]
        elseif love.keyboard.isDown('left') then
            self.player.x = self.player.x - math.max(PLAYER_WALK_SPEED - LEVEL_NUMBER, 60) * dt
            self.player.direction = 'left'
            self.player:checkLeftCollisions(dt)
        elseif love.keyboard.isDown('right') then
            self.player.x = self.player.x + math.max(PLAYER_WALK_SPEED - LEVEL_NUMBER, 60) * dt
            self.player.direction = 'right'
            self.player:checkRightCollisions(dt)
        end
    end

    --[[ Check for entity collisions and take damage if so ]]
    self.player:checkEntityCollisions()

    --[[ Transition into jump state if key is pressed ]]
    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

end
