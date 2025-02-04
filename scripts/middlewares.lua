function setUpDependencies()
    -- smooth scaling
    love.graphics.setDefaultFilter("nearest", "nearest")

    --animation
    anim8 = require 'lib/anim8'

    -- map
    sti = require 'lib/sti'
    gameMap = sti('rsc/map.lua')

    -- colliders
    wf = require 'lib/windfield'
    world = wf.newWorld(0,0)
    
    -- Interact prompt animation
    interactPrompt = {}
    interactPrompt.spriteSheet = love.graphics.newImage("rsc/sprites/e_prompt_sheet.png")
    interactPrompt.grid = anim8.newGrid(18, 18, 36, 18)
    interactPrompt.animation = anim8.newAnimation(interactPrompt.grid('1-2', 1), 0.5)

    drawPrompt = false
    interactTarget = nil

    ones = love.graphics.newImage("rsc/sprites/Ones.png")
    five = love.graphics.newImage("rsc/sprites/five.png")
    zero = love.graphics.newImage("rsc/sprites/zero.png")
    two = love.graphics.newImage("rsc/sprites/two.png")
    three = love.graphics.newImage("rsc/sprites/three.png")

    textBox = {}
    textBox.sprite = love.graphics.newImage("rsc/sprites/textBox.png")
    if gameMap.layers["textBox"] then
        for i, obj in pairs(gameMap.layers["textBox"].objects) do
            textBox.x = obj.x
            textBox.y = obj.y
        end
    end

    spawnOnes = false
    spawnTwo = false
    spawnThree = false
    spawnZero = false
    spawnFive = false
    completion = 0

 
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
        love.graphics.print(math.floor(player.y), 0,10)
        --love.graphics.print(calculateDistance(player.x, player.y, rac.x, rac.y))

    end
end

f3Menu = false

love.window.setMode(1920, 1080)

function drawInteractPrompt(object)
    x_offset = 0
    y_offset = 0
    if object == rac then
        x_offset = 23
        y_offset = -4
    end

    interactPrompt.animation:draw(interactPrompt.spriteSheet, object.x+(x_offset), object.y+(y_offset))
end

function distanceDependentEvents()

    for i, obj in pairs(runes) do
        if calculateDistance(player, obj) < 70 then
            --mySecondDialogue:update(dt)
            interactTarget = obj
            drawPrompt = true
        end
    end

    if calculateDistance(player, rac) < 200 then
        --myDialogue:update(dt)
        interactTarget = rac
        drawPrompt = true
    end
       

end