--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Tile Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This class represents a tile in the tile map of the level
    Help from Harvard GD50 Class - Colton Ogden
]]

Tile = Class{}

--[[
    The Tile Class constructor function

    @x          int   The x-coordinate of the current tile
    @y          int   The y-coordinate of the current tile
    @id         int   The id of the current tile (ground or empty)
    @topper     bool  Whether this specfic tile is a topper tile
    @tileset    int   The number corresponding to which tileset to use in the sprite sheet
    @topperset  int   The number corresponding to which tileset to use in the sprite sheet

    @return void
]]
function Tile:init(x, y, id, topper, tileset, topperset)
    self.x = x
    self.y = y
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    self.id = id
    self.tileset = tileset
    self.topper = topper
    self.topperset = topperset
end

--[[
    Function which checks to see whether this ID is 
    whitelisted as collidable in a global constants table.

    @return bool
]]
function Tile:collidable()
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end
    return false
end

--[[
    The render function on this class.
    Renders the tile based on topper or not
    
    @return void
]]
function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE + 2)

    --[[ Tile top layer for graphical variety ]]
    if self.topper then
        love.graphics.draw(gTextures['toppers'], gFrames['toppersets'][self.topperset][self.id],
            (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
    end
end
