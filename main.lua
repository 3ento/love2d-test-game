require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'

setUpDependencies()
runes = {}
function love.load() 
    dialoguesLoad()
    racoonLoad()
    playerLoad()
    setUpColliders()
    if gameMap.layers["rune_obj"] then
        for i, obj in pairs(gameMap.layers["rune_obj"].objects) do
            local rune = {}
            rune.x = obj.x
            rune.y = obj.y
            table.insert(runes, rune)
        end
    end
end

function love.update(dt)
    playerUpdate(dt)
    camUpdate()
    camPreventOutOfBounds()
    collidersUpdate(dt)
    dialoguesUpdate(dt)
end

function love.draw()
    cam:attach()
        renderAll()
        racTextBox()
        f3MenuCam()
    love.graphics.circle("fill", runes[1].x, runes[1].y, 5)

    cam:detach()
    f3MenuFixed()
    love.graphics.print(calculateDistance(player, runes[1]), 0, 0)

end


