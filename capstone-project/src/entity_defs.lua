--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Entity Object --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    Object which holds static information for entities in the game
]]
ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = .2
            },
            ['idle'] = {
                frames = {4},
                interval = 1
            },
            ['jump'] = {
                frames = {13},
                interval = 1
            },
            ['fall'] = {
                frames = {13},
                interval = 1
            },
            ['power-up'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = .05
            },
            ['hit'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.05,
                looping = false
            }
        }
    },
    ['snail'] = {
        texture = 'creatures',
        type = 'snail',
        walkSpeed = ENTITY_MOVE_SPEED,
        animations = {
            ['move'] = {
                frames = {53, 54},
                interval = 0.5
            },
            ['chase'] = {
                frames = {53, 54},
                interval = 0.5
            },
            ['idle'] = {
                frames = {55},
                interval = 1
            }
        },
        width = 16,
        height = 16,
        health = 1
    },
    ['shark'] = {
        texture = 'shark',
        type = 'shark',
        walkSpeed = ENTITY_MOVE_SPEED,
        animations = {
            ['move'] = {
                frames = {13, 14, 15, 16},
                interval = 0.1
            },
            ['chase'] = {
                frames = {13, 14, 15, 16},
                interval = 0.1
            },
            ['idle'] = {
                frames = {13},
                interval = .5
            }
        },
        width = 20,
        height = 40,
        health = 1
    }
}
