--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Player Jump State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the player is jumping
]]

PlayerJumpState = Class{__includes = BaseState}

--[[
    The PlayerJumpState constructor function

    @player  Player The player object that represents the player in the level
    @gravity int    The amount to add to the players dy in the update function. Simulates gravity

    @return void
]]
function PlayerJumpState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.player.state = 'jump'
    self.player:changeAnimation('jump')
end

--[[
    The enter function for the PlayerJumpState
    Called when state is first entered

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function PlayerJumpState:enter(params)
    gSounds['jump']:play()
    self.player.dy = PLAYER_JUMP_VELOCITY
end

--[[
    The update function for the PlayerJumpState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayerJumpState:update(dt)

    --[[ Set player's upward velocity and y value based on dt and gravity ]]
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + 2 * (self.player.dy * dt)

    --[[ Go into the falling state when the player's y velocity is positive ]]
    if self.player.dy >= 0 then
        self.player:changeState('falling')
    end

    --[[ Look at two tiles above our head and check for collisions ]]
    --[[ 6 pixels of leeway for getting through gaps ]]
    --[[ Help from Harvard GD50 Class - Colton Ogden ]]
    local tileLeft = self.player.map:pointToTile(self.player.x - 3, self.player.y)
    local tileRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y)

    --[[ If the player has a collision up top, go into the falling state immediately ]]
    --[[ Help from Harvard GD50 Class - Colton Ogden ]]
    if (tileLeft and tileRight) and (tileLeft:collidable() or tileRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')
    --[[ Else test his sides for blocks ]]
    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player.x = self.player.x - math.max(PLAYER_WALK_SPEED - LEVEL_NUMBER, 60) * dt
        self.player:checkLeftCollisions(dt)
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player.x = self.player.x + math.max(PLAYER_WALK_SPEED - LEVEL_NUMBER, 60) * dt
        self.player:checkRightCollisions(dt)
    end

    --[[ Check if the player collided with any collidable game objects ]]
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                object.onCollide(object)
                self.player.y = object.y + object.height
                self.player.dy = 0
                self.player:changeState('falling')
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end

    --[[ Check entity and object collisions ]]
    self.player:checkObjectCollisions()
    self.player:checkEntityCollisions()
end
