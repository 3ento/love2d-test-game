require 'scripts/middlewares' 
require 'scripts/shaders'

win_con = false
paperSFX = love.audio.newSource("rsc/sounds/paperAppear.mp3", "static")
paperSFXR = love.audio.newSource("rsc/sounds/papperAppearReverse3.mp3", "static")
endingBGM = love.audio.newSource("rsc/sounds/ending.mp3", "static")
spawnChecks = {
    ["1"] = false, 
    ["2"] = false, 
    ["3"] = false, 
    ["5"] = false, 
    ["0"] = false
}

function winConditions() 
    if showTextBox then 
        for i, obj in pairs(spawnChecks) do 
            if love.keyboard.isDown(i) then
                spawnChecks[i] = true
                break
            end            
        end
        
        if allTrue(spawnChecks) then 
            win_con = true
        end
    end
    
    if win_con then 
        sounds.bgMusic:pause()
        endingBGM:play()
        effect = moonshine(moonshine.effects.glow)
        showTextBox = false
        for i, obj in pairs(spawnChecks) do
            obj = false
        end
    end

end

function textBoxDraw() 
    if showTextBox then 
        if spawnChecks["1"] then
            love.graphics.draw(ones, textBox.x, textBox.y)
        end
        if spawnChecks["2"] then
            love.graphics.draw(two, textBox.x, textBox.y)
        end
        if spawnChecks["3"] then
            love.graphics.draw(three, textBox.x, textBox.y)
        end
        if spawnChecks["0"] then
            love.graphics.draw(zero, textBox.x, textBox.y)
        end
        if spawnChecks["5"] then
            love.graphics.draw(five, textBox.x, textBox.y)
        end
    end
end

function Win()
    showTextBox = false
    walls["rock"]:setType('dynamic')
    gameMap:drawLayer(gameMap.layers["win-con"])
    playerRender()
end
