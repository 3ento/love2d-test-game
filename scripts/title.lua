movingX = 0
w = love.graphics.getWidth()

function scrollBackground(dt)
    -- sets direction of background scroll
    if direction == nil then
        direction = -1 
    end

    --gets the background moving
    movingX = movingX + (20 * dt * direction)

    if movingX <= (2165 - w) * (-1) then
        direction = 1 
    elseif movingX >= 0 then
        direction = -1 
    end

end

function drawScreen(gameState) 
    if gameState == "title" then 
        love.graphics.setColor( 1, 1, 1, opacity)
        love.graphics.draw(love.graphics.newImage("rsc/sprites/titleBg.png"), movingX, 0)
        titleText.animation:draw(titleText.spriteSheet, -100, -100)
    elseif gameState == "game" then
        love.graphics.reset()
        effect(function () 
        cam:attach()
            love.graphics.setColor(1, 1, 1, opacity)
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
        f3MenuFixed()
        drawDialogues()
    elseif gameState == "ending" then
        love.graphics.reset()
        love.graphics.setColor(1, 1, 1, opacity)
        love.graphics.draw(love.graphics.newImage("rsc/sprites/endingBg.png"), movingX, 0)
        endingPhotos.animation:draw(endingPhotos.spriteSheet, movingX, 0)
        endingText.animation:draw(endingText.spriteSheet, -100, -100)
    end
end

function doUpdates(gameState, dt) 
    if gameState=="title" then
        titleText.animation:update(dt)
        fadeIn(opacity, dt)
        scrollBackground(dt)
    elseif gameState=="game" then
        if doFadeOut then
            fadeOut(opacity, dt)
        else 
            fadeIn(opacity, dt)
        end

        interactPrompt.animation:update(dt)
        textBoxAnimated.animation:update(dt)

        playerUpdate(dt)
        camUpdate()
        collidersUpdate(dt)
        distanceDependentEvents(dt)
        updateDialogues(dt)
        winConditions()
    elseif gameState=="ending" then 
        endingPhotos.animation:update(dt)
        endingText.animation:update(dt)
        fadeIn(opacity, dt)
        scrollBackground(dt)
    end
end