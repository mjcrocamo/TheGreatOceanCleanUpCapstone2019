--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Global Constants --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    Some global constants for the application.
]]

--[[ Size of the actual window ]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[ Size we're trying to emulate with push ]]
VIRTUAL_WIDTH = 381
VIRTUAL_HEIGHT = 216

--[[ Level height passed in to level class ]]
LEVEL_MAKER_HEIGHT = 13

--[[ Global standard tile size ]]
TILE_SIZE = 16

--[[ Width and height of screen in tiles ]]
SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE

--[[ Number of tiles in each tile set ]]
TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4

--[[ Number of tile sets in sheet ]]
TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10

--[[ Number of topper sets in sheet ]]
TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 18

--[[
    @const int The intital falling speed for falling game objects
]]
INITIAL_FALLING_SPEED = 25

--[[
    @const int The amount to add to the player score if game object is consumed
]]
GAME_OBJECT_SCORE = 5

--[[
    @const int The amount to add to the player score if the falling game object is consumed during power up
]]
FALLING_GAME_OBJECT_POWER_UP_SCORE = 15

--[[
    @const int The amount to add to the player score if the enemy is consumed during power up
]]
ENEMY_POWER_UP_SCORE = 10

--[[
    @const int The amount to add to the player score if the enemy object is consumed
]]
ENEMY_SCORE = 5

--[[
    @const int The amount to add to the player score if the falling game object is consumed
]]
FALLING_GAME_OBJECT_SCORE = 10

--[[
    @const int The amount to add to the player score if the falling sea turtle game object is consumed
]]
SEA_TURTLE_OBJECT_SCORE = 30

--[[
    @const int The distance between player and enemy in order to start chasing
]]
ENEMY_CHASING_DISTANCE = 5

--[[ Total number of topper and tile sets ]]
TOPPER_SETS = TOPPER_SETS_WIDE * TOPPER_SETS_TALL
TILE_SETS = TILE_SETS_WIDE * TILE_SETS_TALL

--[[ The player walking speed ]]
PLAYER_WALK_SPEED = 90

--[[ The player running speed ]]
PLAYER_RUN_SPEED = 120

--[[ Player jumping velocity ]]
PLAYER_JUMP_VELOCITY = -150

--[[ Enemy movement speed ]]
ENEMY_MOVE_SPEED = 13

-- [[ tile IDs ]]
TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3

--[[ Table of tiles that should trigger a collision ]]
COLLIDABLE_TILES = {
    TILE_ID_GROUND
}
