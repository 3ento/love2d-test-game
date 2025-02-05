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

end

function love.update(dt)
    interactPrompt.animation:update(dt)
    playerUpdate(dt)
    camUpdate()
    camPreventOutOfBounds()
    collidersUpdate(dt)
    distanceDependentEvents()
    updateDialogues(dt)
    winConditions()

    if win_con then 
        effect = moonshine(moonshine.effects.glow)
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
        textBoxDraw()
        f3MenuCam()
    cam:detach()
    if printDebug then 
        love.graphics.print("kur", 0, 0)
    end
    end)
    f3MenuFixed()
    drawDialogues()
end

function love.keypressed(key)
    if key == "e" then
        interactionModules()
    end

    if key == "q" and showRockPrompt then 
        --love.graphics.draw(textBox.sprite, textBox.x, textBox.y)
        showTextBox = not showTextBox
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

