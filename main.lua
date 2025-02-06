require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'
require 'scripts/runes'
require 'scripts/gameplay'

local moonshine = require 'lib/moonshine-master'
function love.load()
    setUpDependencies()
    racoonLoad()
    playerLoad()
    setUpColliders()
    loadRunes()
    setUpDialogues()

    effect = moonshine(moonshine.effects.desaturate).chain(moonshine.effects.vignette)
    effect.desaturate.tint = {17, 17, 132}
    effect.desaturate.strength = 0.7
    effect.vignette.radius = 0.5

    glow = moonshine(moonshine.effects.pixelate)
    glow.min_luma = 0.3
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

    if win_con then 
        effect = moonshine(moonshine.effects.glow)
        showTextBox = false
        for i, obj in pairs(spawnChecks) do
            obj = false
        end
    end

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


    love.graphics.print(myDialogue.currentLine,0,0)

    f3MenuFixed()
    drawDialogues()
end

function love.keypressed(key)
    if key == "e" then
        interactionModules()
    end

    if key == "q" and showRockPrompt then 
        showTextBox = not showTextBox
    end

    -- advance text boxes
    for i, obj in pairs(allDialogue) do
        if myDialogue.currentLine == 7 and not win_con then
            racTextBox = false
        else
            if obj then
                obj:keypressed(key)
            end
        end
    end

    if key == "f3" then
        f3Menu = not f3Menu
    end

end

