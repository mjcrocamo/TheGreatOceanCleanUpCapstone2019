--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Player Falling State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
     This represents the state where the player is falling
]]

PlayerFallingState = Class{__includes = BaseState}

--[[
    The PlayerFallingState constructor function

    @player  Player The player object that represents the player in the level 
    @gravity int    The amount to add to the players dy in the update function. Simulates gravity

    @return void
]]
function PlayerFallingState:init(player, gravity)
    self.player = player
    self.player.state = 'falling'
    self.gravity = gravity
    self.player:changeAnimation('fall')
end

--[[
    The update function for the PlayerFallingState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayerFallingState:update(dt)

    --[[ Set player's downward velocity and y value based on dt and gravity ]]
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    --[[ Look at two tiles below the players feet and check for collisions
        Give more lee way so the character falls more naturally
        Help from GD50 Class - Colton Ogden ]]
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x - 4 + self.player.width - 1, self.player.y + self.player.height)

    --[[ If there is a collision beneath the player
        Help from GD50 Class - Colton Ogden ]]
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        self.player.dy = 0

        --[[ Set the player to be walking or idle on landing depending on input ]]
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            self.player:changeState('walking')
        else
            self.player:changeState('idle')
        end
        self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height

    --[[ Check side collisions on the right or left and reset the player's position ]]
    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player.x = self.player.x - math.max(PLAYER_WALK_SPEED - LEVEL_NUMBER, 60) * dt
        self.player:checkLeftCollisions(dt)
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player.x = self.player.x + math.max(PLAYER_WALK_SPEED - LEVEL_NUMBER, 60) * dt
        self.player:checkRightCollisions(dt)
    end

    --[[ Check if the player has collided with any collidable game objects ]]
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                self.player.dy = 0
                self.player.y = object.y - self.player.height
                if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
                    self.player:changeState('walking')
                else
                    self.player:changeState('idle')
                end
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end
    self.player:checkObjectCollisions()

    --[[ Check for entity collisions and kill them if so ]]
    self.player:checkEntityCollisionKills()
end
