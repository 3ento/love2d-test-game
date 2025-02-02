function love.load() 
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
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 16, 32, 4)
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
    

    love.window.setFullscreen(true)
end

function love.update(dt)
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
    if love.keyboard.isDown('right') then
        vx = player.speed
        player.animations.current = player.animations.right
        player.animations.last = player.animations.right

    elseif love.keyboard.isDown('left') then 
        if player.x > -15 then 
            vx = player.speed * -1
        end
        player.animations.current = player.animations.left
        player.animations.last = player.animations.left

    elseif love.keyboard.isDown('down') then 
        vy = player.speed
        player.animations.current = player.animations.down
        player.animations.last = player.animations.down

    elseif love.keyboard.isDown('up') then 
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

    -- This section prevents the camera from viewing outside the background
    -- First, get width/height of the game window
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w/(2*cam_zoom) then
        cam.x = w/(2*cam_zoom)
    end

    -- Right border
    if cam.y < h/(2*cam_zoom) then
        cam.y = h/(2*cam_zoom)
    end

    -- Get width/height of background
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w/(2*cam_zoom)) then
        cam.x = (mapW - w/(2*cam_zoom))
    end
    -- Bottom border
    if cam.y > (mapH - h/(2*cam_zoom)) then
        cam.y = (mapH - h/(2*cam_zoom))
    end

    -- colliders
    world:update(dt)
    player.x = player.collider:getX() - 32
    player.y = player.collider:getY() - 35
   
end

function love.draw() 
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["behind-the-wall"])
        gameMap:drawLayer(gameMap.layers["Tile Layer 4"])
        gameMap:drawLayer(gameMap.layers["deco"])
        gameMap:drawLayer(gameMap.layers["Tile Layer 3"])
        gameMap:drawLayer(gameMap.layers["stairs-to-level-2"])
        gameMap:drawLayer(gameMap.layers["level-2"])
        gameMap:drawLayer(gameMap.layers["deco-level-2"])
        player.animations.current:draw(player.spriteSheet, player.x, player.y, nil, 2)
        gameMap:drawLayer(gameMap.layers["nature"])
        love.graphics.circle("line", 0, 0, 1)
        love.graphics.circle("fill", 1600, 1600, 1)

        rac.current:draw(rac.spriteSheet, rac.x, rac.y, nil, 2)

        --world:draw()
    cam:detach()

    love.graphics.circle("fill", cam.x, cam.y, 1)
    love.graphics.print(player.x, 0, 0)
    love.graphics.print(player.y, 0, 10)
end