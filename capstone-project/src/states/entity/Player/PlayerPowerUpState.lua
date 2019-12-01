
--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Player Power Up State Class --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    This represents the state where the player is in a special power up state
    He is running, killing and consuming anything in his path
]]

PlayerPowerUpState = Class{__includes = BaseState}

--[[
    @const int The amount of time the player is in the power up state
]]
POWER_UP_TIMER = 4

--[[
    The PlayerIdleState constructor function

    @player Player The player object that represents the player in the level

    @return void
]]
function PlayerPowerUpState:init(player)
    self.player = player
    self.player.powerUp = true
    self.player.state = 'power-up'
    self.player:changeAnimation('power-up')
    self.powerUpTimer = POWER_UP_TIMER
end

--[[
    The update function for the PlayerPowerUpState. Called every dt

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function PlayerPowerUpState:update(dt)

    -- [[ Update the power up timer ]]
    self.powerUpTimer = self.powerUpTimer - dt

    -- [[ If times up, change into falling state ( if on ground will just transition into idle state after )]]
    if self.powerUpTimer <= 0 then
      self.player:changeState('falling')
      self.player.powerUp = false
    else
      self.player.powerUp = true
      gSounds['running']:play()

      --[[ Update player x and run in a certain direction - depending on player direction set ]]
      if self.player.direction == 'right' then
        self.player.x = self.player.x + PLAYER_RUN_SPEED * dt
      else
        self.player.x = self.player.x + (-PLAYER_RUN_SPEED * dt)
      end

      if love.keyboard.isDown('left') then
        self.player.direction = 'left'
      elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
      end

      -- [[ Reverse direction if we reach the game boundaries ]]
      if self.player.x <= 0 then
        self.player.direction = 'right'
      elseif self.player.x > VIRTUAL_WIDTH - self.player.width then
        self.player.direction = 'left'
      end

      --[[ Check if the player collided with any collidable game objects ]]
      for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
      end

      --[[ Check if the player collided with any entities and kill them if so ]]
      self.player:checkEntityCollisionKills()
    end
end
