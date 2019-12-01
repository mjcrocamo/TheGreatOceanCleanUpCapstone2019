--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Enemy Move State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the enemy is idle
    Help from Harvard GD50 Class - Colton Ogden
]]

EnemyMoveState = Class{__includes = BaseState}

--[[
    The EnemyMoveState constructor function

    @tileMap array   The array which stores the x and y of all tiles in the level
    @player  Player  The player object that represents the player in the level
    @enemy   Enemy   The enemy object that represents an enemy to the player in the level

    @return void
]]
function EnemyMoveState:init(tileMap, player, enemy)
    self.tileMap = tileMap
    self.player = player
    self.enemy = enemy
    self.enemy:changeAnimation('move')
    self.movingDirection = math.random(2) == 1 and 'left' or 'right'
    self.enemy.direction = self.movingDirection
    self.movingDuration = math.random(5)
    self.movingTimer = 0
end

--[[
    The update function for the EnemyMoveState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function EnemyMoveState:update(dt)
    --[[ Update the moving timer ]]
    self.movingTimer = self.movingTimer + dt

    --[[ Reset the movement direction and timer if timer is above duration ]]
    if self.movingTimer > self.movingDuration then

        -- [[ Chance to go into idle state randomly ]]
        if math.random(4) == 1 then
            self.enemy:changeState('idle', {

                -- [[ Random amount of time for the enemy to be idle before entering moving state ]]
                wait = math.random(5)
            })
        else
            self.movingDirection = math.random(2) == 1 and 'left' or 'right'
            self.enemy.direction = self.movingDirection
            self.movingTimer = 0
        end
    elseif self.enemy.direction == 'left' then
        self.enemy.x = self.enemy.x - ENEMY_MOVE_SPEED * dt

        -- [[ Stop the enemy if there's a missing tile on the floor to the left or a solid tile directly left ]]
        local tileLeft = self.tileMap:pointToTile(self.enemy.x, self.enemy.y)
        local tileBottomLeft = self.tileMap:pointToTile(self.enemy.x, self.enemy.y + self.enemy.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.enemy.x = self.enemy.x + ENEMY_MOVE_SPEED * dt

            -- [[ Reset direction if we hit a wall ]]
            self.movingDirection = 'right'
            self.enemy.direction = self.movingDirection
            self.movingTimer = 0
        end
    else
        self.enemy.direction = 'right'
        self.enemy.x = self.enemy.x + ENEMY_MOVE_SPEED * dt

        -- [[ Stop the enemy if there's a missing tile on the floor to the right or a solid tile directly right ]]
        local tileRight = self.tileMap:pointToTile(self.enemy.x + self.enemy.width, self.enemy.y)
        local tileBottomRight = self.tileMap:pointToTile(self.enemy.x + self.enemy.width, self.enemy.y + self.enemy.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.enemy.x = self.enemy.x - ENEMY_MOVE_SPEED * dt

            --[[ Reset direction if we hit a wall ]]
            self.movingDirection = 'left'
            self.enemy.direction = self.movingDirection
            self.movingTimer = 0
        end
    end

    --[[ Calculate difference between the enemy and player on the X axis
         and only chase if <= 5 tiles ]]
    local diffX = math.abs(self.player.x - self.enemy.x)

    if diffX < ENEMY_CHASING_DISTANCE * TILE_SIZE then
        self.enemy:changeState('chase')
    end
end
