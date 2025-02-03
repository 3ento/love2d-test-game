require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'

setUpDependencies()
function love.load() 
    dialoguesLoad()
    racoonLoad()
    playerLoad()
    setUpColliders()
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
    cam:detach()
    f3MenuFixed()

end


