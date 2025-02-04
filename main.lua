require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'
require 'scripts/runes'

function love.load() 

    setUpDependencies()
    racoonLoad()
    playerLoad()
    setUpColliders()
    loadRunes()
    setUpDialogues()

    end

function love.update(dt)
    interactPrompt.animation:update(dt)
    playerUpdate(dt)
    camUpdate()
    camPreventOutOfBounds()
    collidersUpdate(dt)
    distanceDependentEvents()
    updateDialogues(dt)
end

function love.draw()
    cam:attach()
        renderAll()
        if drawPrompt then
            drawInteractPrompt(interactTarget, 23, -4)
        end
        f3MenuCam()
    cam:detach()
    f3MenuFixed()
    drawDialogues()
end

function love.keypressed(key)
    if key == "e" then
        interactionModules()
    end

    -- advance text boxes
    for i, obj in pairs(allDialogue) do
        if obj then
            obj:keypressed(key)
        end
    end

    if key == "f3" then
        f3Menu = not f3Menu
    end

end

