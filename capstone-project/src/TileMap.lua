
--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Tile Map Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This class represents a tile map and contains a table of all the tiles in the level
    Help from Harvard GD50 Class - Colton Ogden
]]

TileMap = Class{}

--[[
    The TileMap Class constructor function

    @width  int  The width of the tile map (level)
    @height int  The height of the tile map (level)

    @return void
]]
function TileMap:init(width, height)
    self.width = width
    self.height = height
    self.tiles = {}
end

--[[
    The update function for the TileMap Class. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function TileMap:update(dt)
end

--[[
    Returns the x, y of a tile given an x, y of coordinates in the world space.

    @return Tile
]]
function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil
    end

    return self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x/ TILE_SIZE) + 1]
end

--[[
    The render function on this class.
    Calles render on each tile in the tiles table
    
    @return void
]]
function TileMap:render()
    for y = 9, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:render()
        end
    end
end
