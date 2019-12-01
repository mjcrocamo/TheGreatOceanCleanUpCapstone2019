--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Play State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the player in the game
]]

Player = Class{__includes = Entity}

--[[ 
    Player Class constructor function 
    
    @def object Object containing information to populate Player Object (Extends Entity)
        
    @return void
]]
function Player:init(def)
    Entity.init(self, def)
    self.totalScore = 0
    self.powerUp = false
    self.score = 0
end

--[[
    The update function for the Player Class. Called every dt
    Calls the update function on Entity

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function Player:update(dt)
    Entity.update(self, dt)
end

--[[
    Function which returns if the player is near a projectile

    @target Object The target (projectile) that the player uses to gage if he's near the projectile

    @return bool
]]
function Player:nearProjectile(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

    return not (self.x + self.width < target.x - 2 or self.x > target.x + target.width + 2 or
                selfY + selfHeight < target.y - 2 or selfY > target.y + target.height + 2)
end

--[[
    Checks for object collisions and any collisions to the left of the player
    Help from Harvard GD50 Class - Colton Ogden

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function Player:checkLeftCollisions(dt)

    --[[ Check for left two tiles collision ]]
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)

    --[[ Place player outside the X bounds on one of the tiles to reset any overlap ]]
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - 1
    else

        --[[ Allow player to walk atop solid objects even if he collides with them ]]
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        --[[ Reset X if there's new collided object ]]
        if #collidedObjects > 0 then
            self.x = self.x + PLAYER_WALK_SPEED * dt
        end
    end
end

--[[
    Checks for object collisions and any collisions to the right of the player
    Help from Harvard GD50 Class - Colton Ogden

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function Player:checkRightCollisions(dt)

    --[[ Check for right two tiles collision ]]
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    --[[ Place player outside the X bounds on one of the tiles to reset any overlap ]]
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
    else

        --[[ Allow player to walk atop solid objects even if he collides with them ]]
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        --[[ Reset X if there's new collided object ]]
        if #collidedObjects > 0 then
            self.x = self.x - PLAYER_WALK_SPEED * dt
        end
    end
end

--[[
    Checks for object collisions and any collisions to the right of the player
    Help from Harvard GD50 Class - Colton Ogden

    @return table
]]
function Player:checkObjectCollisions()
    local collidedObjects = {}
    for k, object in pairs(self.level.objects) do
        if object:collides(self) then
            if object.solid then
                table.insert(collidedObjects, object)
            elseif object.consumable then
                object.onConsume(self)
                table.remove(self.level.objects, k)
            end
        end
    end

    return collidedObjects
end

--[[
    Checks for entity collisions with the player
    Give damage to the player if hit

    @return void
]]
function Player:checkEntityCollisions()
    for k, entity in pairs(self.level.entities) do
        if entity:collides(self) and not self.invulnerable then
          self:damage(1)
          self:goInvulnerable(2)
          gSounds['hit-player']:play()
        end
    end
end

--[[
    Checks for entity collisions with the player
    Kill the entity if the player collides with it

    @return void
]]
function Player:checkEntityCollisionKills()
    for k, entity in pairs(self.level.entities) do
        if entity:collides(self) then
            gSounds['kill']:play()
            if self.powerUp then
                self.score = self.score + ENEMY_POWER_UP_SCORE
                self.totalScore = self.totalScore + ENEMY_POWER_UP_SCORE
            else
                self.score = self.score + ENEMY_SCORE
                self.totalScore = self.totalScore + ENEMY_SCORE
            end
            table.remove(self.level.entities, k)
        end
    end
end

--[[
    The render function on this class.
    Renders the player by calling render on the Entity Class
    
    @return void
]]
function Player:render()
    Entity.render(self)
end
