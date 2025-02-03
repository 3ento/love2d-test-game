function love.load() 
    f3Menu = false

    -- smooth scaling
    love.graphics.setDefaultFilter("nearest", "nearest")

    --animation
    anim8 = require 'lib/anim8'

    --camera
    camera = require 'lib/camera'
    cam = camera()

    -- map
    sti = require 'lib/sti'
    gameMap = sti('rsc/map.lua')

    -- colliders
    wf = require 'lib/windfield'
    world = wf.newWorld(0,0)

    -- dialog boxes
    moan = require('lib/Moan')
    Moan.speak("Title", {"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean efficitur feugiat nisi quis mollis.\nQuisque sodales purus eget sem mollis tincidunt."})
    Moan.setSpeed("fast")
    moan.autoWrap = true

    --racoon
    rac = {}
    rac.x = 720
    rac.y = 35
    rac.spriteSheet = love.graphics.newImage('rsc/sprites/RACCOONSPRITESHEET.png')
    rac.grid = anim8.newGrid(32, 32, rac.spriteSheet:getWidth(),  rac.spriteSheet:getHeight())
    rac.current = anim8.newAnimation(rac.grid('1-4', 1), 0.7)

    -- player
    player = {}
    player.speed = 250
    player.x = 400
    player.y = 350
    player.spriteSheet = love.graphics.newImage('rsc/sprites/cat_sprite.png')
    player.grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(),  player.spriteSheet:getHeight())
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 16, 32, 12)
    player.collider:setFixedRotation(true)

    -- animations
    player.animations = {}
    player.animations.last = player.animations.up

    -- --idle animations
    player.animations.idleUp = anim8.newAnimation( player.grid('1-4', 4), 0.7)
    player.animations.idleDown = anim8.newAnimation( player.grid('1-4', 1), 0.7)
    player.animations.idleLeft = anim8.newAnimation( player.grid('1-4', 3), 0.7)
    player.animations.idleRight = anim8.newAnimation( player.grid('1-4', 2), 0.7)

    -- --movement animations
    player.animations.down = anim8.newAnimation( player.grid('1-4', 6), 0.2)
    player.animations.up = anim8.newAnimation( player.grid('1-4', 12), 0.2)
    player.animations.left = anim8.newAnimation( player.grid('1-4', 8), 0.2)
    player.animations.right = anim8.newAnimation( player.grid('1-4', 10), 0.2)

    -- walls
    walls = {}
    if gameMap.layers["walls"] then
        for i, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    if gameMap.layers["rock"] then
        for i, obj in pairs(gameMap.layers["rock"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end

    love.window.setMode(1920, 1080)
end

function love.update(dt)
    Moan.update(dt)
    --movement
    vx = 0
    vy = 0

    -- -- deafult animation
    player.animations.current = player.animations.idleDown

    -- --idles
    if player.animations.last == player.animations.right then 
        player.animations.current = player.animations.idleRight
    elseif player.animations.last == player.animations.left then
        player.animations.current = player.animations.idleLeft
    elseif player.animations.last == player.animations.down then
        player.animations.current = player.animations.idleDown
    elseif player.animations.last == player.animations.up then
        player.animations.curret = player.animations.idleUp
    end

    -- --cardinal
    if love.keyboard.isDown('right') or love.keyboard.isDown("d") then
        vx = player.speed
        player.animations.current = player.animations.right
        player.animations.last = player.animations.right

    elseif love.keyboard.isDown('left') or love.keyboard.isDown("a") then 
        if player.x > -15 then 
            vx = player.speed * -1
        end
        player.animations.current = player.animations.left
        player.animations.last = player.animations.left
    end

    if love.keyboard.isDown('down') or love.keyboard.isDown("s") then 
        vy = player.speed
        player.animations.current = player.animations.down
        player.animations.last = player.animations.down

    elseif love.keyboard.isDown('up') or love.keyboard.isDown("w") then 
        if player.y > -30 then 
            vy = player.speed * -1
        end 
        player.animations.current = player.animations.up
        player.animations.last = player.animations.up

    end

    player.collider:setLinearVelocity(vx, vy)
    player.animations.current:update(dt)
    rac.current:update(dt)

    -- camera
    cam_zoom = 3
    cam:lookAt(player.x, player.y)
    cam:zoomTo(cam_zoom)

    -- prevent camera from going out of bounds
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/(2*cam_zoom) then
        cam.x = w/(2*cam_zoom)
    end

    if cam.y < h/(2*cam_zoom) then
        cam.y = h/(2*cam_zoom)
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w/(2*cam_zoom)) then
        cam.x = (mapW - w/(2*cam_zoom))
    end
    if cam.y > (mapH - h/(2*cam_zoom)) then
        cam.y = (mapH - h/(2*cam_zoom))
    end

    -- colliders
    world:update(dt)
    player.x = player.collider:getX() - 32
    player.y = player.collider:getY() - 35

    if calculateDistance(player.x, player.y, rac.x, rac.y) > 180 then
        textBox = false
    end

    
end

function love.draw()

    cam:attach()
        -- order of map rendering
        gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["behind-the-wall"])
        gameMap:drawLayer(gameMap.layers["upper-wall"])
        gameMap:drawLayer(gameMap.layers["deco"])
        gameMap:drawLayer(gameMap.layers["bottom-wall-back"])
        -- player render
        player.animations.current:draw(player.spriteSheet, player.x, player.y, nil, 2)
        gameMap:drawLayer(gameMap.layers["bottom-wall-front"])
        gameMap:drawLayer(gameMap.layers["stairs-to-level-2"])
        gameMap:drawLayer(gameMap.layers["deco-level-2"])
        gameMap:drawLayer(gameMap.layers["nature"])

        -- render the racoon NPC
        rac.current:draw(rac.spriteSheet, rac.x, rac.y, nil, 2)

        if f3Menu then
            -- show hitboxes
            world:draw()
        end

        if calculateDistance(player.x, player.y, rac.x, rac.y) < 180 then
            love.graphics.rectangle("line", rac.x+22, rac.y-5, 20, 20, 6)
            love.graphics.rectangle("fill", rac.x+2.5+22, rac.y+2.5-5, 15, 15, 6)
            love.graphics.setColor(0, 0 ,0)
            love.graphics.print("E", rac.x+2.5+22+3.5, rac.y+2.5-5)
            love.graphics.reset()

            love.keypressed(key, scancode, isrepeat)
            
        end

        if textBox then
            Moan.draw(3)
        end

    cam:detach()

    
    if f3Menu then
        --love.graphics.print(math.floor(player.x), 0,0)
        --love.graphics.print(math.floor(player.y), 0,10)
        love.graphics.print(calculateDistance(player.x, player.y, rac.x, rac.y))
    end
    
end

function calculateDistance(x1, y1, x0, y0) 
    return math.sqrt((x0-x1)^2 + (y0-y1)^2)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "e" and calculateDistance(player.x, player.y, rac.x, rac.y) < 180 then
       textBox = true
    end
    if key == "f3" then
        f3Menu = not f3Menu
    end
 end


