--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Game Object Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents a game object within the levels/ game
]]

GameObject = Class{}

--[[
    The Game Object Class constructor function

    @def Object Object containing information to populate Game Object

    @return void
]]
function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.type = def.type
    self.opacity = 255
    self.stateMachine = def.stateMachine
    self.state = ''
    self.states = def.states
    self.minusable = def.minusable
    self.dx = 0
    self.dy = 0

    --[[ Default empty collision callback ]]
    self.onCollide = function() end

    --[[ Default empty consume callback ]]
    self.onConsume = function() end
end

--[[
    Function used to change game object state

    @state  string The name of the state to change to
    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function GameObject:changeState(state, params)
    self.stateMachine:change(state, params)
end

--[[
    Function which calculates if this game object collides with a target

    @target GameObject Another entity/gameObject which is used to check collisions

    @return bool
]]
function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y + 7 > self.y + self.height or self.y > target.y + target.height)
end

--[[
    The update function for the Game Object Class. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function GameObject:update(dt)
    if self.stateMachine then
        self.stateMachine:update(dt)
    end
end

--[[
    The render function on this class.
    Renders the game object
    
    @return void
]]
function GameObject:render()
    love.graphics.setColor(255, 255, 255, self.opacity)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
end
