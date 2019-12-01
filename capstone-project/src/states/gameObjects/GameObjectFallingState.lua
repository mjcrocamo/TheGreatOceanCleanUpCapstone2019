--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Game Object Falling State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This is the state that controls falling game objects
]]
GameObjectFallingState = Class{__includes = BaseState}

--[[
    The GameObjectFallingState constructor function

    @object       GameObject The current GameObject transitioning into falling state
    @fallingSpeed int        The current game object falling speed
    @level        Level      The current level object
    @player       Player     The player object that represents the player in the level

    @return void
]]
function GameObjectFallingState:init(object, fallingSpeed, level, player)
    self.gameObject = object
    self.fallingSpeed = fallingSpeed
    self.level = level
    self.player = player
end

--[[
    The update function for the PauseState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function GameObjectFallingState:update(dt)

  --[[ Set the falling speed ]]
    self.gameObject.dy = self.fallingSpeed
    self.gameObject.y = self.gameObject.y + (self.gameObject.dy * dt)

    --[[ Look at two tiles at the bottom of the game object and check for collisions ]]
    local tileBottomLeft = self.level.tileMap:pointToTile(self.gameObject.x, self.gameObject.y + self.gameObject.height)
    local tileBottomRight = self.level.tileMap:pointToTile(self.gameObject.x + self.gameObject.width, self.gameObject.y + self.gameObject.height)

    --[[ Stop the game object when it collides with teh ground ]]
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
      self.gameObject.dy = 0
      self.gameObject.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.gameObject.height
    end

    --[[ If the object collides with the ground, remove it from the objects table/ the level ]]
    -- [[ Adjust the score if an object collides with the ground ]]
    local types = {'starfish', 'heart', 'sea-turtle'}
    for k, object in pairs(self.level.objects) do
      if tileBottomLeft then
        if object.dy == 0 and object.y == ((tileBottomLeft.y - 1) * TILE_SIZE - self.gameObject.height) then
            table.remove(self.level.objects, k)
            if self.player.score >= 20 and object.minusable then
              self.player.score = math.max(self.player.score - GAME_OBJECT_SCORE, 20)
              self.player.totalScore = math.max(self.player.totalScore - GAME_OBJECT_SCORE, 20)
            end
        end
      end
    end

end
