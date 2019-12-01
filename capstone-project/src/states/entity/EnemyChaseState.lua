--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Enemy Chase State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the enemy is chasing the player
    Help from Harvard GD50 Class - Colton Ogden
]]

EnemyChaseState = Class{__includes = BaseState}

--[[
    The EnemyChaseState constructor function

    @tileMap array   The array which stores the x and y of all tiles in the level
    @player  Player  The player object that represents the player in the level
    @enemy   Enemy   The enemy object that represents an enemy to the player in the level

    @return void
]]
function EnemyChaseState:init(tileMap, player, enemy)
    self.tileMap = tileMap
    self.player = player
    self.enemy = enemy
    self.enemy:changeAnimation('chase')
end

--[[
    The update function for the EnemyChaseState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function EnemyChaseState:update(dt)

    --[[ Calculate difference between the enemy and player on 
        the X axis and only chase if <= 5 tiles ]]
    local diffX = math.abs(self.player.x - self.enemy.x)

    if diffX > ENEMY_CHASING_DISTANCE * TILE_SIZE then
        self.enemy:changeState('move')
    elseif self.player.x < self.enemy.x then
        self.enemy.direction = 'left'
        self.enemy.x = self.enemy.x - ENEMY_MOVE_SPEED * dt

        --[[ Stop the enemy if there's a missing tile on the floor to 
            the left or a solid tile directly to the left 
            Help from Harvard GD50 Class - Colton Ogden ]]
        local tileLeft = self.tileMap:pointToTile(self.enemy.x, self.enemy.y)
        local tileBottomLeft = self.tileMap:pointToTile(self.enemy.x, self.enemy.y + self.enemy.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.enemy.x = self.enemy.x + ENEMY_MOVE_SPEED * dt
        end
    else
        self.enemy.direction = 'right'
        self.enemy.x = self.enemy.x + ENEMY_MOVE_SPEED * dt

        --[[ Stop the enemy if there's a missing tile on the floor to 
            the right or a solid tile directly to the left 
            Help from Harvard GD50 Class - Colton Ogden ]]
        local tileRight = self.tileMap:pointToTile(self.enemy.x + self.enemy.width, self.enemy.y)
        local tileBottomRight = self.tileMap:pointToTile(self.enemy.x + self.enemy.width, self.enemy.y + self.enemy.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.enemy.x = self.enemy.x - ENEMY_MOVE_SPEED * dt
        end
    end

end
