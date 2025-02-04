require 'scripts/middlewares'

setUpDependencies()
function setUpColliders()
    -- walls
    walls = {}
    if gameMap.layers["walls"] then
        for i, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    if gameMap.layers["rock"] then
        for i, obj in pairs(gameMap.layers["rock"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            walls["rock"] =  wall
        end
    end
end

function collidersUpdate(dt)
    -- colliders
    world:update(dt)
    player.x = player.collider:getX() - 32
    player.y = player.collider:getY() - 35
end