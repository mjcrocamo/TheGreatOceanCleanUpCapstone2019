--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Dependencies --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    Libraries and files needed to run the game
]]

--[[
    The "Class" library. Allows us to represent anything in
    our game as code, rather than keeping track of many disparate variables and
   methods
   https://github.com/vrld/hump/blob/master/class.lua
]]
Class = require 'lib/class'

Event = require 'lib/knife.event'

--[[
    Push is a library that will allow us to draw our game at a virtual
    resolution, instead of however large our window is; used to provide
    a more retro aesthetic: https://github.com/Ulydev/push
]]
push = require 'lib/push'

--[[
    Library used for Timers and Tweening
]]
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/GameObject'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'
require 'src/Tile'
require 'src/TileMap'
require 'src/Enemy'
require 'src/entity_defs'
require 'src/game_objects'
require 'src/Hitbox'

require 'src/states/BaseState'
require 'src/Level/Level'

require 'src/states/entity/EnemyIdleState'
require 'src/states/entity/EnemyMoveState'
require 'src/states/entity/EnemyChaseState'

require 'src/states/entity/Player/PlayerIdleState'
require 'src/states/entity/Player/PlayerWalkingState'
require 'src/states/entity/Player/PlayerJumpState'
require 'src/states/entity/Player/PlayerFallingState'
require 'src/states/entity/Player/PlayerPowerUpState'
require 'src/states/entity/Player/PlayerSwingHitState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/PauseState'
require 'src/states/game/NextLevelCountdownState'

require 'src/states/gameObjects/GameObjectFallingState'

--[[
    Global sound object
]]
gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav'),
    ['death'] = love.audio.newSource('sounds/death.wav'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav'),
    ['kill'] = love.audio.newSource('sounds/kill.wav'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav'),
    ['running'] = love.audio.newSource('sounds/running.wav'),
    ['clock'] = love.audio.newSource('sounds/clock.wav'),
    ['pause'] = love.audio.newSource('sounds/Pickup_Coin3.wav', 'static'),
    ['game-music'] = love.audio.newSource('sounds/HappyPixieTown.mp3'),
    ['sword'] = love.audio.newSource('sounds/sword.wav'),
}

--[[
    Global textures object
]]
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['gold'] = love.graphics.newImage('graphics/gold.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
    ['starfish'] = love.graphics.newImage('graphics/red-starfish-eyes.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['shark'] = love.graphics.newImage('graphics/sharkResize.png'),
    ['startEnd'] = love.graphics.newImage('graphics/startEndBackground.jpg'),
    ['background'] = love.graphics.newImage('graphics/playBackground.jpg'),
    ['diver'] = love.graphics.newImage('graphics/penguinDiverResize1.png'),
    ['coke-can'] = love.graphics.newImage('graphics/cokecan.png'),
    ['coke-bottle'] = love.graphics.newImage('graphics/cokebottle.png'),
    ['cup-straw'] = love.graphics.newImage('graphics/cupandstraw.png'),
    ['detergent'] = love.graphics.newImage('graphics/detergent.png'),
    ['hair-spray'] = love.graphics.newImage('graphics/hairspray.png'),
    ['milk-carton'] = love.graphics.newImage('graphics/milkcarton.png'),
    ['rings'] = love.graphics.newImage('graphics/perforated_rings.png'),
    ['tin-can'] = love.graphics.newImage('graphics/tincan.png'),
    ['water-bottle'] = love.graphics.newImage('graphics/waterbottle.png'),
    ['sea-turtle'] = love.graphics.newImage('graphics/happySeaTurtle.png')
}

--[[
    Global frames object. Generates quads from textures
]]
gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['toppers'] = GenerateQuads(gTextures['toppers'], 16, 16),
    ['gold'] = GenerateQuads(gTextures['gold'], 16, 16),
    ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16),
    ['starfish'] = GenerateQuads(gTextures['starfish'], 16, 16),
    ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['shark'] = GenerateQuads(gTextures['shark'], 66, 40),
    ['diver'] = GenerateQuads(gTextures['diver'], 33, 40),
    ['coke-can'] = GenerateQuads(gTextures['coke-can'], 12, 22),
    ['coke-bottle'] = GenerateQuads(gTextures['coke-bottle'], 9, 25),
    ['cup-straw'] = GenerateQuads(gTextures['cup-straw'], 14, 22),
    ['detergent'] = GenerateQuads(gTextures['detergent'], 17, 22),
    ['hair-spray'] = GenerateQuads(gTextures['hair-spray'], 10, 22),
    ['milk-carton'] = GenerateQuads(gTextures['milk-carton'], 15, 22),
    ['rings'] = GenerateQuads(gTextures['rings'], 29, 17),
    ['tin-can'] = GenerateQuads(gTextures['tin-can'], 12, 22),
    ['water-bottle'] = GenerateQuads(gTextures['water-bottle'], 8, 22),
    ['sea-turtle'] = GenerateQuads(gTextures['sea-turtle'], 43, 44)

}

-- [[ These need to be added after gFrames is initialized because they refer to gFrames from within ]]
gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'],
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'],
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

--[[
    Global fonts object
]]
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['smallFlappy'] = love.graphics.newFont('fonts/flappy.ttf', 14),
    ['mediumSmallFlappy'] = love.graphics.newFont('fonts/flappy.ttf', 28),
    ['mediumFlappy'] = love.graphics.newFont('fonts/flappy.ttf', 46),
    ['largeFlappy'] = love.graphics.newFont('fonts/flappy.ttf', 56)
}
