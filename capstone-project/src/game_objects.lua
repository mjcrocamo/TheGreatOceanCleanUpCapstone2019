--[[
    Capstone 2019
    The Great Ocean Clean Up

    -- Game Object --

    Author: Maggie Crocamo
    Email: mjcrocamo@gmail.com, mjc494@g.harvard.edu
]]

--[[
    Object which holds static information for game objects in the game
]]

GAME_OBJECT_DEFS = {
    ['starfish'] = {
        type = 'starfish',
        texture = 'starfish',
        frame = 1,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        consumable = true,
        minusable = false
    },
    ['gold'] = {
        type = 'gold',
        texture = 'gold',
        frame = 1,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        consumable = true,
        minusable = false
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        consumable = true,
        isHeart = true,
        isProjectile = false,
        isLifted = false,
        minusable = false
      },
      ['gems'] = {
        type = 'gems',
        texture = 'gems',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        consumable = true,
        minusable = false
    },
    ['sea-turtle'] = {
        type = 'sea-turtle',
        texture = 'sea-turtle',
        width = 43,
        height = 44,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = false
    },
    ['coke-can'] = {
        type = 'coke-can',
        texture = 'coke-can',
        width = 14,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['coke-bottle'] = {
        type = 'coke-bottle',
        texture = 'coke-bottle',
        width = 12,
        height = 25,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['cup-straw'] = {
        type = 'cup-straw',
        texture = 'cup-straw',
        width = 16,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['detergent'] = {
        type = 'detergent',
        texture = 'detergent',
        width = 20,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['hair-spray'] = {
        type = 'hair-spray',
        texture = 'hair-spray',
        width = 16,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['milk-carton'] = {
        type = 'milk-carton',
        texture = 'milk-carton',
        width = 17,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['rings'] = {
        type = 'rings',
        texture = 'rings',
        width = 29,
        height = 17,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['tin-can'] = {
        type = 'tin-can',
        texture = 'tin-can',
        width = 15,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    },
    ['water-bottle'] = {
        type = 'water-bottle',
        texture = 'water-bottle',
        width = 12,
        height = 22,
        frame = 1,
        collidable = true,
        consumable = true,
        solid = false,
        minusable = true
    }
}