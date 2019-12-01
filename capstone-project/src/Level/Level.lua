--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- The Level Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
   The level class, generates the level at the start and has functions which
   generate the enemies and game objects throughout the level/ game
]]

Level = Class{}

--[[
    Level Constructor function

    @width      int The width of the level
    @height     int The height of the level
    @levelTimer int The inital timer value for the level

    @return void
]]
function Level:init(width, height, levelTimer)
    self.entities = {}
    self.objects = {}
    self.tileMap = {}
    self.width = width
    self.height = height
    self.levelTimer = levelTimer
    self.fallingSpeed = INITIAL_FALLING_SPEED + (LEVEL_NUMBER * 0.20)
end

--[[
    Function which generates a generic game object and inserts it into the objects table

    @def       object   Object containing information to populate GameObject
    @x         int      The starting x of the game object
    @y         int      The starting y of the game object
    @onConsume function The object onConsume callback function. Called when object is consumed
    @onCollide function The object onCollide callback function. Called when object is collided (has to be solid)

    @return void
]]
function Level:generateGameObject(def, x, y, onConsume, onCollide)
    local gameObject = GameObject(def)
    gameObject.x = x
    gameObject.y = y
    gameObject.onConsume = onConsume
    gameObject.onCollide = onCollide
    table.insert(self.objects, gameObject)
end

--[[
    Function which spawns the static game objects in the level
    onConsume function adds points to player's score
    Becomes harder to generate objects as the levels progress

    @return void
]]
function Level:spawnGameObjects()
    local types = {'gold', 'gems'}
    for x = 1, self.width do
        for y = 11, self.height do
            if self.tileMap.tiles[y][x].topper then
                if math.random(math.max(5 + LEVEL_NUMBER, 30)) == 1 then 
                    local type = types[math.random(#types)]
                    local object = self:generateGameObject(
                        GAME_OBJECT_DEFS[type], 
                        (x - 1) * TILE_SIZE, 
                        VIRTUAL_HEIGHT - (4 * TILE_SIZE) - 10, 
                        function(player)
                            gSounds['pickup']:play()
                            player.score = player.score + GAME_OBJECT_SCORE
                            player.totalScore = player.totalScore + GAME_OBJECT_SCORE
                        end
                        )
                    table.insert(self.objects, object)
                end
            end 
        end 
    end
end

--[[
    Generates the initial level (called in PlayState)
    Lays out the tiles and generates the static game objects

    @return self
]]
function Level:generate()
    local tiles = {}
    local tileID = TILE_ID_GROUND

    --[[ whether we should draw our tiles with toppers ]]
    local topper = true

    --[[ Randomly choose which tiles and topper sets from sprite sheet show ]]
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- [[ Insert blank tables into tiles for later access ]]
    for x = 1, self.height do
        table.insert(tiles, {})
    end

    -- [[ Generate tiles column by column ]]
    for x = 1, self.width do
        tileID = TILE_ID_EMPTY

        -- [[ Lay out the empty space ]]
        for y = 9, 12 do
            table.insert(tiles[y],Tile(x, y, tileID, nil, tileset, topperset))
        end

        tileID = TILE_ID_GROUND

        for y = 13, self.height do
            table.insert(tiles[y],Tile(x, y, tileID, y == 13 and topper or nil, tileset, topperset))
        end

        -- [[ Chance to spawn a single tile pillar ]]
        if math.random(math.max(20 - LEVEL_NUMBER, 2)) == 1 and x <= (self.width - 5) and LEVEL_NUMBER > 5 then
            tiles[12][x] = Tile(x, 12, tileID, topper, tileset, topperset)
            tiles[13][x].topper = nil

            -- [[ Chance to spawn a double tile pillar ]]
            if math.random(math.max(20 - LEVEL_NUMBER, 8)) == 1 and x <= (self.width - 5) and LEVEL_NUMBER > 8 then
                tiles[11][x] = Tile(x, 11, tileID, topper, tileset, topperset)
                tiles[12][x] = Tile(x, 12, tileID, nil, tileset, topperset)
                tiles[13][x].topper = nil
            end
        end
    end

    self.tileMap = TileMap(self.width, self.height)
    self.tileMap.tiles = tiles
    self:spawnGameObjects()

    return self

end

--[[
    Function which returns a falling game object

    @def       object   Object containing information to populate GameObject
    @x         int      The starting x of the game object
    @y         int      The starting y of the game object
    @onConsume function The object onConsume callback function. Called when object is consumed
    @onCollide function The object onCollide callback function. Called when object is collided (has to be solid)

    @return GameObject
]]
function Level:generateFallingGameObject(def, x, y, player, onConsume, onCollide)
    local object = GameObject(def)
    object.x = x
    object.y = y
    object.onConsume = onConsume
    object.onCollide = onCollide
    object.stateMachine = StateMachine {
        ['falling'] = function() return GameObjectFallingState(object, self.fallingSpeed, self, player) end
    }
    return object
end

--[[
    Function which dynmically generates the falling game objects in the level
    Gets called every second using Timer API

    @gamePlayer Player The player object representing the player in the level

    @return void
]]
function Level:generateFallingGameObjects(gamePlayer)

    local types = {'coke-can', 'coke-bottle','cup-straw', 'detergent', 'hair-spray', 'milk-carton', 'rings', 'tin-can', 'water-bottle'}

    Timer.every(2, function()

        --[[ Chance to generate a normal falling game object in the first 4 levels ]]
        if math.random(2) == 1 and LEVEL_NUMBER <= 6 then
            local type = types[math.random(#types)]
            local object = self:generateFallingGameObject(
                GAME_OBJECT_DEFS[type], 
                math.random(VIRTUAL_WIDTH - TILE_SIZE), 
                -TILE_SIZE, 
                gamePlayer,
                function(player)
                    gSounds['pickup']:play()
                    player.score = player.score + FALLING_GAME_OBJECT_SCORE
                    player.totalScore = player.totalScore + FALLING_GAME_OBJECT_SCORE
                end
            )
            object:changeState('falling')
            table.insert(self.objects, object)
        end

        --[[ Chance to generate a heart falling game object, level 5+ ]]
        if math.random(10 + LEVEL_NUMBER) == 1 and LEVEL_NUMBER >= 5 then
            local object = self:generateFallingGameObject(
                GAME_OBJECT_DEFS['heart'],
                math.random(VIRTUAL_WIDTH - TILE_SIZE), 
                -TILE_SIZE,
                gamePlayer,
                function(player)
                    if player.health < 7 then
                        player.health = player.health + 2
                    elseif player.health == 7 then
                        player.health = player.health + 1
                    else
                        player.health = player.health
                    end
                    gSounds['pickup']:play()
                end
            )
            object:changeState('falling')
            table.insert(self.objects, object)
        end

        --[[ Chance to generate a starfish falling game object (power up), level 5+ ]]
        if math.random(10 + LEVEL_NUMBER) == 1 and LEVEL_NUMBER >= 5 then
            local object = self:generateFallingGameObject(
                GAME_OBJECT_DEFS['starfish'],
                math.random(VIRTUAL_WIDTH - TILE_SIZE), 
                -TILE_SIZE,
                gamePlayer,
                function(player)
                    player:changeState('power-up')
                    gSounds['pickup']:play()
                end
            )
            object:changeState('falling')
            table.insert(self.objects, object)
        end

        --[[ Chance to generate a normal falling game object, level 5+ ]]
        if LEVEL_NUMBER >= 7 then
            local type = types[math.random(#types)]
            local object = self:generateFallingGameObject(
                GAME_OBJECT_DEFS[type],
                math.random(VIRTUAL_WIDTH - TILE_SIZE), 
                -TILE_SIZE, 
                gamePlayer,
                function(player)
                    gSounds['pickup']:play()
                    if player.powerUp then
                        player.score = player.score + FALLING_GAME_OBJECT_POWER_UP_SCORE
                        player.totalScore = player.totalScore + FALLING_GAME_OBJECT_POWER_UP_SCORE
                    else
                        player.score = player.score + FALLING_GAME_OBJECT_SCORE
                        player.totalScore = player.totalScore + FALLING_GAME_OBJECT_SCORE
                    end
                end
            )
            object:changeState('falling')
            table.insert(self.objects, object)
        end
    end)
end

--[[
    Function which returns an enemy object (extends entity)

    @def      object  Object containing information to populate Enemy Object
    @x        int     The starting x of the enemy
    @y        int     The starting y of the enemy
    @player   Player  The current Player Object for the level

    @return Enemy
]]
function Level:spawnEnemy(def, x, y, player)
    local enemy = Enemy(def)
    enemy.x = x
    enemy.y = y
    enemy.stateMachine = StateMachine {
        ['idle'] = function() return EnemyIdleState(self.tileMap, player, enemy) end,
        ['move'] = function() return EnemyMoveState(self.tileMap, player, enemy) end,
        ['chase'] = function() return EnemyChaseState(self.tileMap, player, enemy) end
    }
    return enemy
end

--[[
    Function which generates the one sea turtle in the level
    Chance to spawn is decided in the PlayState

    @gamePlayer Player The player object representing the player in the level

    @return void
]]
function Level:spawnSeaTurtle(gamePlayer)
        local object = self:generateFallingGameObject(
            GAME_OBJECT_DEFS['sea-turtle'],
            math.random(VIRTUAL_WIDTH - TILE_SIZE), 
             -TILE_SIZE,
             gamePlayer,
            function(player)
                gSounds['powerup-reveal']:play()
                player.score = player.score + SEA_TURTLE_OBJECT_SCORE
                player.totalScore = player.totalScore + SEA_TURTLE_OBJECT_SCORE
                LEVEL_NUMBER = LEVEL_NUMBER + 1
                gStateMachine:change('next-level-countdown', {
                    player = player,
                    levelNumber = LEVEL_NUMBER
                })
            end
        )
        object:changeState('falling')
        table.insert(self.objects, object)
end

--[[
    Function which dynamically spawns new enemies every 8 seconds using Timer API

    @player Player The player object representing the player in the level

    @return void
]]
function Level:dynamicallySpawnEnemies(player)
    Timer.every(16, function()
        self:spawnEnemies(player)
    end)
end

--[[
    Function which chooses randomly which type of enemy to spawn in the level

    @player Player The player object representing the player in the level

    @return void
]]
function Level:spawnEnemies(player)

    local types = {'shark', 'snail'}

    for x = 1, VIRTUAL_WIDTH do
        for y = 11, LEVEL_MAKER_HEIGHT do
            if self.tileMap.tiles[y][x].topper and self.tileMap.tiles[y][x].x <= VIRTUAL_WIDTH - TILE_SIZE then
                local type = types[math.random(#types)]
                if math.random(math.max(30 - LEVEL_NUMBER, 5)) == 1 then 
                    local enemy = {}
                    if type == 'shark' then
                        enemy = self:spawnEnemy(
                            ENTITY_DEFS[type],
                            (x - 1) * TILE_SIZE,
                            (y - 2) * TILE_SIZE - 22,
                            player
                        )
                    else
                        enemy = self:spawnEnemy(
                            ENTITY_DEFS[type],
                            (x - 1) * TILE_SIZE,
                            (y - 2) * TILE_SIZE + 2,
                            player
                        )
                    end
                    enemy:changeState('idle', {
                            wait = math.random(5)
                    })
                    table.insert(self.entities, enemy)
                end
            end 
        end 
    end
end


--[[
    Clears the objects and entities in the object and entity 
    tables if they have nil references
    Help from Harvard GD50 Class - Colton Ogden

    @return void
]]
function Level:clear()
    for i = #self.objects, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end

    for i = #self.entities, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end
end

--[[
    Calls the update functions on the objects and entities in the level
    Help from Harvard GD50 Class - Colton Ogden

    @return void
]]
function Level:update(dt)
    self.tileMap:update(dt)

    for k, object in pairs(self.objects) do
        object:update(dt)
    end

    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

--[[
    Calls the render function on the tiles, objects, and entities in the level
    Help from Harvard GD50 Class - Colton Ogden
    
    @return void
]]
function Level:render()
    self.tileMap:render()

    for k, object in pairs(self.objects) do
        object:render()
    end

    for k, entity in pairs(self.entities) do
       entity:render()
    end
end
