require "scripts/dialogues"
require "scripts/gameplay"
require "scripts/middlewares"

rac = {}
rac.x = 720
rac.y = 35
rac.spriteSheet = love.graphics.newImage('rsc/sprites/RACCOONSPRITESHEET.png')
rac.grid = anim8.newGrid(32, 32, rac.spriteSheet:getWidth(),  rac.spriteSheet:getHeight())
rac.current = anim8.newAnimation(rac.grid('1-4', 1), 0.7)

function racoonRender()
    -- render the racoon NPC
    rac.current:draw(rac.spriteSheet, rac.x, rac.y, nil, 2)
end
