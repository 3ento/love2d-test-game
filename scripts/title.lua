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

    titleText.animation:update(dt)
end