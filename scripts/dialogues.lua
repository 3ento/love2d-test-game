function dialoguesLoad()
    -- dialog boxes
    moan = require('lib/Moan')
    Moan.speak("Title", {"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean efficitur feugiat nisi quis mollis.\nQuisque sodales purus eget sem mollis tincidunt."})
    Moan.setSpeed("fast")
    moan.autoWrap = true
end

function dialoguesUpdate(dt)
    Moan.update(dt)

    if calculateDistance(player, rac) > 180 then
        textBox = false
    end
end

function racTextBox()
    if calculateDistance(player, rac) < 180 then
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
end