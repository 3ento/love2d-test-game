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

function love.load()
    gameState = "title"
    doFadeOut = false

    setUpDependencies()
    playerLoad()
    setUpShaders()
end

function love.update(dt)
    doUpdates(gameState, dt)
    if gameState == "game" and opacity < 0 then
        gameState = "ending"
    end
end

function love.draw()
    drawScreen(gameState)
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
        if calculateDistance(player, rac) < 230 then

            if racDialogue.currentLine == 6 and not win_con then
                racDialogue:keypressed(key)
                racTextBox = false
            elseif racDialogue.currentLine == 10 then
                doFadeOut = true
            elseif racDialogue.currentLine == 7 and not win_con then
            else 
                typingSFX:play()
                racDialogue:keypressed(key)
            end
        end
    end

    -- debug menu
    if key == "f3" then
        f3Menu = not f3Menu
    end

    if key == "j" then
        win_con = true
    end

end