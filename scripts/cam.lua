--camera
camera = require 'lib/camera'
cam = camera()

function camPreventOutOfBounds()
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
end

function camUpdate() 
    -- camera
    cam_zoom = 3
    cam:lookAt(player.x, player.y)
    cam:zoomTo(cam_zoom)
end