require "scripts/dialogues"

--animation
anim8 = require 'lib/anim8'

-- map
sti = require 'lib/sti'
gameMap = sti('rsc/map.lua')

-- colliders
wf = require 'lib/windfield'
world = wf.newWorld(0,0)

interactPromptForRock = {}
interactPromptForRock.spriteSheet = love.graphics.newImage("rsc/sprites/q_prompt_sheet.png")
interactPromptForRock.grid = anim8.newGrid(18, 18, 36, 18)
interactPromptForRock.animation = anim8.newAnimation(interactPromptForRock.grid('1-2', 1), 0.5)

bgMusic = love.audio.newSource("rsc/sounds/background_music.wav", "stream")
love.audio.setVolume(0.3)
bgMusic:play()

f3Menu = false

--love.window.setMode(1920, 1080)
love.window.setFullscreen(true)

runes = {}
if gameMap.layers["rune_obj"] then
    for i, obj in pairs(gameMap.layers["rune_obj"].objects) do
        local rune = {}
        rune.x = obj.x
        rune.y = obj.y
        rune.idx = obj.name
        rune.mssg = runeMessages[rune.idx]
        table.insert(runes, rune)
    end
end

function setUpDependencies()
    --camera
    camera = require 'lib/camera'
    cam = camera()

    -- smooth scaling
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Interact prompt animation
    interactPrompt = {}
    interactPrompt.spriteSheet = love.graphics.newImage("rsc/sprites/e_prompt_sheet.png")
    interactPrompt.grid = anim8.newGrid(18, 18, 36, 18)
    interactPrompt.animation = anim8.newAnimation(interactPrompt.grid('1-2', 1), 0.5)
    
    titleText = {}
    titleText.spriteSheet = love.graphics.newImage("rsc/sprites/titleSheet.png")
    titleText.grid = anim8.newGrid(2165, 1246, 4330, 1246)
    titleText.animation = anim8.newAnimation(titleText.grid('1-2', 1), 0.9)

    endingPhotos = {}
    endingPhotos.spriteSheet = love.graphics.newImage("rsc/sprites/endingPhotosSheet.png")
    endingPhotos.grid = anim8.newGrid(2165, 1246, 4330, 1246)
    endingPhotos.animation = anim8.newAnimation(endingPhotos.grid('1-2', 1), 0.9)

    endingText = {}
    endingText.spriteSheet = love.graphics.newImage("rsc/sprites/endingTextSheet.png")
    endingText.grid = anim8.newGrid(2165, 1246, 4330, 1246)
    endingText.animation = anim8.newAnimation(endingText.grid('1-2', 1), 0.9)

    drawPrompt = false
    interactTarget = nil

    textBox = {}
    textBox.sprite = love.graphics.newImage("rsc/sprites/textBox.png")

    textBoxAnimated = {}
    textBoxAnimated.spriteSheet = love.graphics.newImage("rsc/sprites/textBoxIdle.png")
    textBoxAnimated.grid = anim8.newGrid(300, 52, 600, 52) 
    textBoxAnimated.animation = anim8.newAnimation(textBoxAnimated.grid('1-2', 1), 0.5)

    if gameMap.layers["textBox"] then
        for i, obj in pairs(gameMap.layers["textBox"].objects) do
            textBox.x = obj.x
            textBox.y = obj.y
        end
    end

    opacity = 0
end

-- obj1 has to be the player
function calculateDistance(obj1, obj2) 
    return math.sqrt(((obj1.x+35)-obj2.x)^2 + ((obj1.y+32)-obj2.y)^2)
end

function f3MenuCam() 
    if f3Menu then
        -- show hitboxes
        world:draw()
        love.graphics.circle("fill", player.x, player.y, 5)
    end
end

function f3MenuFixed() 
    if f3Menu then
        love.graphics.print(math.floor(player.x), 0,0)
        love.graphics.print(math.floor(player.y), 0,20)
        love.graphics.print(tostring(textBoxAnimated.animation.position), 0,50)
        --love.graphics.print(calculateDistance(player.x, player.y, rac.x, rac.y))
    end
end

function drawInteractPrompt(object)
    x_offset = 0
    y_offset = 0
    if object == rac then
        x_offset = 23
        y_offset = -4
    end

    if showRockPrompt then 
        interactPromptForRock.animation:draw(interactPromptForRock.spriteSheet, rockObj.x, rockObj.y)
    end

    interactPrompt.animation:draw(interactPrompt.spriteSheet, object.x+(x_offset), object.y+(y_offset))
end

function distanceDependentEvents(dt)
    for i, obj in pairs(runes) do
        if calculateDistance(player, obj) < 70 then
            if obj.idx == "rock" then 
                showRockPrompt = true
                rockObj = obj
            end
            interactTarget = obj
            drawPrompt = true
            break
        else
            drawPrompt = false
        end
    end

    if calculateDistance(player, rac) < 200 then
        interactTarget = rac
        drawPrompt = true
    end

end

function allTrue(t)
    for _, v in pairs(t) do
        if not v[1] then return false end
    end

    return true
end

function fadeIn(opcaity, dt)
    -- fade in
    if opacity < 1 then
        opacity = opacity + 0.75*dt
    end
end

function fadeOut(opcaity, dt)
    -- fade in
    if opacity ~= 0 then
        opacity = opacity - 0.75*dt
    end
end