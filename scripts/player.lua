function playerLoad()
    --animation
    anim8 = require 'lib/anim8'

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
end



function playerUpdate(dt)
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
end

function playerRender()
    -- player render
    player.animations.current:draw(player.spriteSheet, player.x, player.y, nil, 2)
end