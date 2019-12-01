--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The main.lua file. Point of entry. Runs the game --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu

    Art packs:
    https://opengameart.org/
    https://www.spriters-resource.com/pc_computer/maplestory/sheet/22477/ -- Credit: Ripped by Boo
    https://www.123rf.com/photo_58735361_happy-sea-turtle-cartoon.html -- Sea Turle -- Standard License
    Photo 157222149 © Allexxandar - Dreamstime.com - Play State Background Image -- Standard License
    Photo 156624271 © Kravtzov - Dreamstime.com - Start and Game Over State Background Image -- Standard License

    Music:
    https://freesound.org/
    https://opengameart.org/content/hitctrl-happy-pixie-town Credit: Hit-Ctrl

    Some code used in this game was based off of Harvard GD50 Class - Intro to Game Development with Lua and Love2D
]]

--[[
    The main.lua file. The main entry point. This loads the game with LOVE2D Framework
]]

require 'src/Dependencies'

--[[
    Intitalize the global level number
]]
LEVEL_NUMBER = 1

--[[
    love.load() function provided by LOVE2D framework. Loads intital
        and sets initial parameters required to load the game
    
    @return void
]]
function love.load()

    --[[ Initialize our nearest-neighbor filter ]]
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --[[ App window title ]]
    love.graphics.setFont(gFonts['zelda-small'])
    love.window.setTitle("The Great Ocean Clean up")

    --[[ Seed the Random Number Generator (RNG)]]
    math.randomseed(os.time())

    --[[ Initialize our virtual resolution ]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    --[[ Initialize global state machine for the game ]]
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['pause'] = function() return PauseState() end,
        ['next-level-countdown'] = function() return NextLevelCountdownState() end
    }
    gStateMachine:change('start')

    --[[ Kick off the music ]]
    gSounds['game-music']:setLooping(true)
    gSounds['game-music']:setVolume(0.7)
    gSounds['game-music']:play()

    --[[ Initialize input table ]]
    love.keyboard.keysPressed = {}
end

--[[
    Function from Love2D that resizes the game window 
    with push library when game window is resized

    @w int Width of virtual window
    @h int Height of virtual window

    @return
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    If escape key is pressed, kills the game
    Else it adds the key to the table of keys pressed in current frame

    @key The key that was pressed

    @return void
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    --[[ Add to our table of keys pressed this frame ]]
    love.keyboard.keysPressed[key] = true
end

--[[
    Returns the key that was pressed

    @key The key that was pressed

    @return key
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    love.update() method. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

--[[
    love.draw() method. Renders everything within the game that 
    needs to be rendered

    @return void
]]
function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end
