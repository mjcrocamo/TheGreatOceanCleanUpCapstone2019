--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Enemy Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the enemy (AI) in the game
    Extends the entity class
]]

Enemy = Class{__includes = Entity}

--[[ 
    Enemy Class constructor function 
    
    @def object Object containing information to populate Enemy Object
        
    @return void
]]
function Enemy:init(def)
    Entity.init(self, def)
end

--[[
    The render function on this class.
    Renders the enemy animation
    
    @return void
]]
function Enemy:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 8, 0, self.direction == 'left' and 1 or -1, 1, 8, 10)
end
