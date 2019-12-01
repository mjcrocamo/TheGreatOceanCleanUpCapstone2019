--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Enemy Idle State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the enemy is idle
    Help from Harvard GD50 Class - Colton Ogden
]]

EnemyIdleState = Class{__includes = BaseState}

--[[
    The EnemyIdleState constructor function

    @tileMap array   The array which stores the x and y of all tiles in the level
    @player  Player  The player object that represents the player in the level
    @enemy   Enemy   The enemy object that represents an enemy to the player in the level

    @return void
]]
function EnemyIdleState:init(tileMap, player, enemy)
    self.tileMap = tileMap
    self.player = player
    self.enemy = enemy
    self.waitTimer = 0
    self.enemy:changeAnimation('idle')
end

--[[
    The enter function for the EnemyIdleState
    Called when state is first entered
    This sets the initial wait period, used to decide when enemy enters move state

    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function EnemyIdleState:enter(params)
    self.waitPeriod = params.wait
end

--[[
    The update function for the EnemyIdleState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function EnemyIdleState:update(dt)

    --[[ When the wait timer is less than the inital wait period, enter the move state ]]
    if self.waitTimer < self.waitPeriod then
        self.waitTimer = self.waitTimer + dt
    else
        self.enemy:changeState('move')
    end

    --[[ Calculate the difference between enemy and player on X axis
         and only chase if <= 5 tiles ]]
    local diffX = math.abs(self.player.x - self.enemy.x)

    if diffX < ENEMY_CHASING_DISTANCE * TILE_SIZE then
        self.enemy:changeState('chase')
    end
end
