require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'
require 'scripts/runes'
require 'scripts/gameplay'
require 'scripts/shaders'

function love.load()
    sounds = {}
    sounds.bgMusic = love.audio.newSource("rsc/sounds/background_music.wav", "stream")
    love.audio.setVolume(0.3)
    sounds.bgMusic:play()

    setUpDependencies()
    racoonLoad()
    playerLoad()
    setUpColliders()
    loadRunes()
    setUpDialogues()
    setUpShaders()
end

function love.update(dt)
    interactPrompt.animation:update(dt)
    playerUpdate(dt)
    camUpdate()
    camPreventOutOfBounds()
    collidersUpdate(dt)
    distanceDependentEvents(dt)
    updateDialogues(dt)
    winConditions()
end

function love.draw()
    effect(function () 
    cam:attach()
        renderAll()
        if drawPrompt then
            drawInteractPrompt(interactTarget, 23, -4)
        end
        if showTextBox then
            love.graphics.draw(textBox.sprite, textBox.x, textBox.y)
        end
        if win_con then 
            Win()
        end
        textBoxDraw()
        f3MenuCam()
    cam:detach()
    end)
    f3MenuFixed()
    drawDialogues()
end

function love.keypressed(key)
    if key == "e" then
        interactionModules()
    end

    if key == "q" and showRockPrompt then 
        if showTextBox then
            paperSFXR:play()
        else
            paperSFX:play()
        end
        showTextBox = not showTextBox
    end

    -- advance text boxes
    if key == "space" then
        for i, obj in pairs(allDialogue) do
            if myDialogue.currentLine == 7 and not win_con then
                racTextBox = false
            else
                if obj then
                    if obj == myDialogue then
                        typingSFX:play()
                    end
                    obj:keypressed(key)
                end
            end
        end
    end

    if key == "f3" then
        f3Menu = not f3Menu
    end

end

