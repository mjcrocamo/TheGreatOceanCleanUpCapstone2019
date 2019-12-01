--[[
		Capstone 2019
		The Great Ocean Clean Up

		-- The StateMachine Class --

		Author: Maggie Crocamo
		Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
		The State Machine class which controls the states and 
		state changes of entities, gameObjects, and the game itself
]]

StateMachine = Class{}

--[[ 
		StateMachine constructor function 
			
		@states object The table object which holds the different states of the state machine
    
    @return void
]]
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {}
	self.current = self.empty
end

--[[
		Function which implements a change in state

		@stateName   string The name of the state
		@enterParams Object Params (optional) passed to the enter state only

		@return void
]]
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName])
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

--[[
    The update function for the State Machine Class. Called every dt
    If enter is pressed, un-pause the game

    @dt int The delta-time variable provided by LOVE2D Framework. 
            The amount of time since the update function was last called: https://love2d.org/wiki/dt

    @return void
]]
function StateMachine:update(dt)
	self.current:update(dt)
end

--[[
    The render function on this class.
    Renders everything within the current state
    
    @return void
]]
function StateMachine:render()
	self.current:render()
end
