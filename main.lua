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
            --player.x = player.x - 2 
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

    

    -- camera
    cam:lookAt(player.x, player.y)
    cam:zoomTo(2)

    if player.x < 150 then
        cam:lockX(200, cam.smooth.linear(25))
    end
    
    -- colliders
    world:update(dt)
    player.x = player.collider:getX() - 32
    player.y = player.collider:getY() - 35
   
end

function love.draw() 
    cam:attach()
        gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["deco"])
        player.animations.current:draw(player.spriteSheet, player.x, player.y, nil, 2)
        world:draw()
    cam:detach()

    --love.graphics.print(player.x, 0, 0)
    --love.graphics.print(player.y, 0, 10)
end