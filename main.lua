require 'scripts/player'
require 'scripts/racoon'
require 'scripts/middlewares'
require 'scripts/cam'
require 'scripts/colliders'
require 'scripts/dialogues'
require 'scripts/mapRenderOrder'
require 'scripts/gameplay'
require 'scripts/shaders'
require 'scripts/title'

--[[
    Animate the paper and numbers
    Add sfx to the numbers
    (?) Make dialog boxes disappear out of range
    (?) Add some animated map assets
    End Screen
    ( :( ) Optimization ((srly why does it run so shit gd))
    Fix code not appearing
    Change music after winning
    (!!!) Rune messages don't appear when game is played properly
]]

function love.load()
    gameState = "title"
    doFadeOut = false

    setUpDependencies()
    playerLoad()
    setUpShaders()
end

function love.update(dt)
    if gameState == "title" then
        fadeIn(opacity, dt)
        scrollBackground(dt)
    elseif gameState == "game" then
        if doFadeOut then
            fadeOut(opacity, dt)
            if opacity < 0 then
                gameState = "ending"
            end
        else 
            fadeIn(opacity, dt)
        end
        interactPrompt.animation:update(dt)
        playerUpdate(dt)
        camUpdate()
        collidersUpdate(dt)
        distanceDependentEvents(dt)
        updateDialogues(dt)
        winConditions()
        textBoxAnimated.animation:update(dt)

    elseif gameState == "ending" then
        endingPhotos.animation:update(dt)
        endingText.animation:update(dt)
        fadeIn(opacity, dt)
        scrollBackground(dt)
    end
    
end

function love.draw()
    if gameState == "title" then
        love.graphics.setColor( 1, 1, 1, opacity)
        love.graphics.draw(love.graphics.newImage("rsc/sprites/titleBg.png"), movingX, 0)
        titleText.animation:draw(titleText.spriteSheet, -100, -100)
        --love.graphics.print(opacity, 0, 0)
    elseif gameState == "game" then
        effect(function () 
        cam:attach()
            love.graphics.setColor( 1, 1, 1, opacity)
            renderAll()
            if drawPrompt then
                drawInteractPrompt(interactTarget)
            end
            if showTextBox then
                textBoxAnimated.animation:draw(textBoxAnimated.spriteSheet, textBox.x, textBox.y)
            end
            if win_con then 
                Win()
            end
            textBoxDraw()
            f3MenuCam()
        cam:detach()
        end)
        --[[love.graphics.print(tostring(myDialogue.currentLine), 0 ,0)
        love.graphics.print(tostring(doFadeOut), 0 ,20)
        love.graphics.print(tostring(gameState), 0 ,50)
        love.graphics.print(tostring(runeMessages["1"][2]), 0 ,100)]]
        f3MenuFixed()
        drawDialogues()
    elseif gameState == "ending" then
        love.graphics.setColor( 1, 1, 1, opacity)
        love.graphics.draw(love.graphics.newImage("rsc/sprites/endingBg.png"), movingX, 0)
        endingPhotos.animation:draw(endingPhotos.spriteSheet, movingX, 0)
        endingText.animation:draw(endingText.spriteSheet, -100, -100)
    end
end

function love.keypressed(key)
    -- open dialogues
    if key == "e" then
        interactionModules()
        if gameState == "title" then
            opacity = 0
            typingSFX:play()
            gameState = "game"
        end
    end

    -- open code textbox
    if key == "q" and showRockPrompt then 
        if showTextBox then
            paperSFXR:play()
        else
            paperSFX:play()
        end
        showTextBox = not showTextBox
    end

    -- advance dialogues
    if key == "space" then
        if myDialogue.currentLine == 6 and not win_con then
            racTextBox = false
            myDialogue.currentLine = 7
        elseif myDialogue.currentLine == 10 then
            doFadeOut = true
        end
        typingSFX:play()
        myDialogue:keypressed(key)
    end

    -- debug menu
    if key == "f3" then
        f3Menu = not f3Menu
    end

    if key == "j" then
        win_con = true
    end

end