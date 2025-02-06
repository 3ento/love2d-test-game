require 'scripts/middlewares' 

win_con = false
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
    --[[if love.keyboard.isDown("1") then 
        spawnOnes = true
    end
    if love.keyboard.isDown("2") then 
        spawnTwo = true
    end
    if love.keyboard.isDown("3") then 
        spawnThree = true
    end
    if love.keyboard.isDown("5") then 
        spawnFive = true
    end
    if love.keyboard.isDown("0") then 
        spawnZero = true
    end]]

    --[[if spawnFive and spawnOnes and spawnThree and spawnTwo and spawnTwo and spawnZero then
        win_con = true
        walls["rock"]:setType('dynamic')
    end]]
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
