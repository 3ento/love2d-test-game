win_con = false

function winConditions() 
    if love.keyboard.isDown("1") then 
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
    end

    if spawnFive and spawnOnes and spawnThree and spawnTwo and spawnTwo and spawnZero then
        win_con = true
        walls["rock"]:setType('dynamic')
    end
end

function textBoxDraw() 
    --love.graphics.draw(textBox.sprite, textBox.x, textBox.y)
    if spawnOnes then
        love.graphics.draw(ones, textBox.x, textBox.y)
        completion = completion + 1
    end
    if spawnTwo then
        love.graphics.draw(two, textBox.x, textBox.y)
        completion = completion + 1
    end
    if spawnThree then
        love.graphics.draw(three, textBox.x, textBox.y)
        completion = completion + 1
    end
    if spawnZero then
        love.graphics.draw(zero, textBox.x, textBox.y)
        completion = completion + 1
    end
    if spawnFive then
        love.graphics.draw(five, textBox.x, textBox.y)
        completion = completion + 1
    end
end

function Win()
    gameMap:drawLayer(gameMap.layers["ground"])
        gameMap:drawLayer(gameMap.layers["behind-the-wall"])
        gameMap:drawLayer(gameMap.layers["upper-wall"])
        gameMap:drawLayer(gameMap.layers["deco"])
        gameMap:drawLayer(gameMap.layers["bottom-wall-back"])
        gameMap:drawLayer(gameMap.layers["runes"])
        gameMap:drawLayer(gameMap.layers["level-2-runes"])
        gameMap:drawLayer(gameMap.layers["rock"])
        gameMap:drawLayer(gameMap.layers["win-con"])
        gameMap:drawLayer(gameMap.layers["deco-level-2"])

        racoonRender()
        playerRender()
    
        gameMap:drawLayer(gameMap.layers["bottom-wall-front"])
        gameMap:drawLayer(gameMap.layers["stairs-to-level-2"])
        gameMap:drawLayer(gameMap.layers["nature"])
end
