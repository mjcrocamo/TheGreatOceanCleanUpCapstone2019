--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Utility Functions --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    Contains utility functions used throughout the game
    Help from Harvard GD50 Class - Colton Ogden
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles in the atlast, split the texture into
    all of the quads by dividing it evenly.

    @atlas  texture  A texture with multiple sprites
    @width  int      The width of the quads
    @height int      The height of the quads

    @return table
]]
function GenerateQuads(atlas, width, height)
    local sheetWidth = atlas:getWidth() / width
    local sheetHeight = atlas:getHeight() / height

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spriteSheet[sheetCounter] =
                love.graphics.newQuad(x * width, y * height, width,
                height, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end

--[[
    Divides quads we've generated via slicing our tile sheet into separate tile sets.

    @quads  table The quads generated from a texture from GenerateQuads function
    @setsX  int   X of tile sets in the sheet
    @setsY  int   Y of tile sets in the sheet
    @sizeX  int   X of the Size of the tile sets in the sheet
    @sizeY  int   Y of the size of the tile sets in the sheet

    @return table
]]
function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tileSets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    --[[ For each tile set on the X and Y ]]
    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do

            --[[ TileSet table ]]
            table.insert(tileSets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tileSets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tileSets
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
