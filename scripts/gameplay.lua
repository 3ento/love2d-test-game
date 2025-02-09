require 'scripts/middlewares'
require 'scripts/shaders'
require 'scripts/colliders'

win_con = false
paperSFX = love.audio.newSource("rsc/sounds/paperAppear.mp3", "static")
paperSFXR = love.audio.newSource("rsc/sounds/papperAppearReverse.mp3", "static")
endingBGM = love.audio.newSource("rsc/sounds/ending.mp3", "static")

ones = love.graphics.newImage("rsc/sprites/Ones.png")
five = love.graphics.newImage("rsc/sprites/five.png")
zero = love.graphics.newImage("rsc/sprites/zero.png")
two = love.graphics.newImage("rsc/sprites/two.png")
three = love.graphics.newImage("rsc/sprites/three.png")

spawnChecks = {
    ["1"] = {false, ones}, 
    ["2"] = {false, two}, 
    ["3"] = {false, three}, 
    ["5"] = {false, five}, 
    ["0"] = {false, zero}
}

function winConditions() 
    if showTextBox then 
        for i, obj in pairs(spawnChecks) do 
            if love.keyboard.isDown(i) then
                spawnChecks[i][1] = true
                break
            end            
        end
        
        if allTrue(spawnChecks) then 
            win_con = true
        end
    end
    
    if win_con then 
        bgMusic:pause()
        endingBGM:play()
        effect = moonshine(moonshine.effects.glow)
        showTextBox = false
        for i, obj in pairs(spawnChecks) do
            obj[1] = false
        end
    end

end

function textBoxDraw() 
    if showTextBox then 
        for i, obj in pairs(spawnChecks) do
            if spawnChecks[i][1] then
                love.graphics.draw(spawnChecks[i][2], textBox.x, textBox.y)
                --break
            end
        end
    end
end

function Win()
    showTextBox = false
    walls["rock"]:setType('dynamic')
    gameMap:drawLayer(gameMap.layers["win-con"])
    playerRender()
end
