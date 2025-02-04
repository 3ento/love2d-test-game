require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'
require 'scripts/runes'

LoveDialogue = require "lib/Love-Dialogue-main/LoveDialogue"
function love.load() 
    --[[showRune1 = false
    showRune2 = false
    showRune3 = false
    racTextBox = false]]

    setUpDependencies()
    racoonLoad()
    playerLoad()
    setUpColliders()
    loadRunes()

    myDialogue = LoveDialogue.play("rsc/dialogues/rac.ld")
    runeMssg1 = LoveDialogue.play("rsc/dialogues/rune1.ld")
    runeMssg2 = LoveDialogue.play("rsc/dialogues/rune2.ld")
    runeMssg3 = LoveDialogue.play("rsc/dialogues/rune3.ld")
    runeMssg4 = LoveDialogue.play("rsc/dialogues/rune4.ld")
    runeMssg5 = LoveDialogue.play("rsc/dialogues/rune5.ld")
    runeMssg6 = LoveDialogue.play("rsc/dialogues/rune6.ld")

    allDialogue = {myDialogue, runeMssg1, runeMssg2, runeMssg3, runeMssg4, runeMssg5, runeMssg6}
end

function love.update(dt)
    interactPrompt.animation:update(dt)
    playerUpdate(dt)
    camUpdate()
    camPreventOutOfBounds()
    collidersUpdate(dt)
    distanceDependentEvents()

    myDialogue:update(dt)
    runeMssg1:update(dt)
    runeMssg2:update(dt)
    runeMssg3:update(dt)
    runeMssg4:update(dt)
    runeMssg5:update(dt)
    runeMssg6:update(dt)
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

    if showRune1 then 
        runeMssg1:draw()
    end

    if showRune2 then
        runeMssg2:draw()
    end

    if racTextBox then
        myDialogue:draw()
    end

    if showRune3 then 
        runeMssg3:draw()
    end

    if showRune4 then 
        runeMssg4:draw()
    end

    if showRune5 then 
        runeMssg5:draw()
    end
    if showRune6 then 
        runeMssg6:draw()
    end
end

function love.keypressed(key)
    if key == "e" then
        if calculateDistance(player, rac) < 180 then
            if racTextBox then 
                myDialogue.isActive = not myDialogue.isActive
            end
            racTextBox = true
        end

        for i, obj in pairs(runes) do
            if calculateDistance(player, obj) < 80 then
                if obj.idx == "1" then
                    if showRune1 then
                        runeMssg1.isActive = not runeMssg1.isActive
                    end
                    showRune1 = true
                end

                if obj.idx == "2" then
                    if showRune2 then 
                        runeMssg2.isActive = not runeMssg2.isActive
                    end
                    showRune2 = true
                end

                if obj.idx == "3" then
                    if showRune3 then 
                        runeMssg3.isActive = not runeMssg3.isActive
                    end
                    showRune3 = true
                end

                if obj.idx == "4" then
                    if showRune4 then 
                        runeMssg4.isActive = not runeMssg4.isActive
                    end
                    showRune4 = true
                end

                if obj.idx == "5" then
                    if showRune5 then 
                        runeMssg5.isActive = not runeMssg5.isActive
                    end
                    showRune5 = true
                end

                if obj.idx == "6" then
                    if showRune6 then 
                        runeMssg6.isActive = not runeMssg6.isActive
                    end
                    showRune6 = true
                end
            end
        end
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

