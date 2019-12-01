--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Hitbox Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    The class that represents a hit-box. A box defined by x and y with a width and height where
    enemies are vulnerable to be hit by the player
]]

Hitbox = Class{}

--[[ 
    Hitbox Class constructor function 
    
    @def    object Object containing information to populate Enemy Object
    @x      int    The x-coordinate of the current hitbox
    @y      int    The y-coordinate of the current hitbox
    @width  int    The width of the hitbox
    @height int    The height of the hitbox
        
    @return void
]]
function Hitbox:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end