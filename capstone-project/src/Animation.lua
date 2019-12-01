--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Animation Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This is the animation class. Contains functions to assist with getting current player
    animation and updates current player animation
    Help from Harvard GD50 Class - Colton Ogden
]]

Animation = Class{}

--[[ 
    Animation State constructor function 
        
    @def object Object containing information to populate Animation Class
    
    @return void
]]
function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture
    self.looping = def.looping or true
    self.timer = 0
    self.currentFrame = 1

    --[[ Used to see if we've seen a whole loop of the animation ]]
    self.timesPlayed = 0
end

--[[
    Refreshes the current animation class
    Resets frames, timer, and amount of times played on animation class

    @return void
]]
function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

--[[
    The update function for the Animation Class. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function Animation:update(dt)
    --[[ If not a looping animation and we've played at least once, exit ]]
    if not self.looping and self.timesPlayed > 0 then
        return
    end

    --[[ Update animation if there's more than one frame ]]
    if #self.frames > 1 then
        self.timer = self.timer + dt

        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))

            --[[ if we've looped back to the beginning, record ]]
            if self.currentFrame == 1 then
                self.timesPlayed = self.timesPlayed + 1
            end
        end
    end
end

--[[
    Returns the actual animation based on the current frame provided
    
    @return The animation of the current frame
]]
function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end
