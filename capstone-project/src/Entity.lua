--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Entity Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents an entity in the game (either player or AI)
]]

Entity = Class{}

--[[ 
    Entity Class constructor function 
    
    @def object Object containing information to populate Enemy Object
    @x   int    The x-coordinate of the current entity
    @y   int    The y-coordinate of the current entity
        
    @return void
]]
function Entity:init(def, x, y)
    --[[ Entity position ]]
    self.x = def.x
    self.y = def.y

    --[[ Entity velocity ]]
    self.dx = 0
    self.dy = 0

    --[[ Entity dimensions ]]
    self.width = def.width
    self.height = def.height

    --[[ Entity textures, animations, direction, and stateMachine ]]
    self.texture = def.texture
    self.animations = self:createAnimations(def.animations)
    self.walkSpeed = def.walkSpeed
    self.stateMachine = def.stateMachine
    self.direction = def.direction or 'left'

    --[[ Reference to tile map so we can check collisions ]]
    self.map = def.map

    --[[ Reference to level for tests against other entities + objects ]]
    self.level = def.level

    --[[ Entity health ]]
    self.health = def.health

    --[[ Flags for flashing the entity when hit ]]
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0

    --[[ Timer for turning transparency on and off, flashing ]]
    self.flashTimer = 0
end

--[[
    Function used to change entity state

    @state  string The name of the state to change to
    @params Object Params (optional) passed to this state when entering into state

    @return void
]]
function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

--[[
    Function used to grab the current entity animation

    @name string The name of the texture used to generate the animation

    @return void
]]
function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

--[[
    Function to create all of the animations based on Entity paramters

    @animations Object The static animation paramaters for the entity

    @return Object animations
]]
function Entity:createAnimations(animations)
    local animationsReturned = {}
    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end
    return animationsReturned
end

--[[
    The update function for the Entity Class. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function Entity:update(dt)

  --[[ Show entity flashing if invulnerable ]]
  if self.invulnerable then
      self.flashTimer = self.flashTimer + dt
      self.invulnerableTimer = self.invulnerableTimer + dt

      if self.invulnerableTimer > self.invulnerableDuration then
          self.invulnerable = false
          self.invulnerableTimer = 0
          self.invulnerableDuration = 0
          self.flashTimer = 0
      end
  end

    --[[ Update the entity's state machine ]]
    self.stateMachine:update(dt)

    --[[ Update the entity's current animation ]]
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

--[[
    Function which decreases entity health if they take damage

    @return void
]]
function Entity:damage(dmg)
    self.health = self.health - dmg
end

--[[
    Function which sets entity to invulnerable for a certain amount of time

    @duration int The amount of time the entity will stay in an invulnerable state

    @return void
]]
function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

--[[
    Function which calculates if this entity collides with a target

    @entity Entity Another entity which is used to check collisions

    @return bool
]]
function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

--[[
    The render function on this class.
    Renders the entity, and also version where entity is invulnerable
    
    @return void
]]
function Entity:render()
  
  --[[ Draw sprite slightly transparent if invulnerable every 0.06 seconds ]]
  if self.invulnerable and self.flashTimer > 0.06 then
      self.flashTimer = 0
      love.graphics.setColor(255, 255, 255, 64)
  end
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
    math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'left' and 1 or -1, 1, 8, 10)
end
