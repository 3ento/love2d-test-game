function setUpDependencies()
    -- smooth scaling
    love.graphics.setDefaultFilter("nearest", "nearest")

    --animation
    anim8 = require 'lib/anim8'

    -- map
    sti = require 'lib/sti'
    gameMap = sti('rsc/map.lua')

    -- colliders
    wf = require 'lib/windfield'
    world = wf.newWorld(0,0)
end

-- obj1 has to be the player
function calculateDistance(obj1, obj2) 
    return math.sqrt(((obj1.x+35)-obj2.x)^2 + ((obj1.y+32)-obj2.y)^2)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "e" and calculateDistance(player, rac) < 180 then
       textBox = true
    end
    if key == "f3" then
        f3Menu = not f3Menu
    end
end

function f3MenuCam() 
    if f3Menu then
        -- show hitboxes
        world:draw()
        love.graphics.circle("fill", player.x, player.y, 5)

    end
end

function f3MenuFixed() 
    if f3Menu then
        love.graphics.print(math.floor(player.x), 0,0)
        love.graphics.print(math.floor(player.y), 0,10)
        --love.graphics.print(calculateDistance(player.x, player.y, rac.x, rac.y))

    end
end

f3Menu = false

love.window.setMode(1920, 1080)