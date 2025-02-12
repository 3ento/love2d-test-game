require "scripts/middlewares"

function renderAll() 
    gameMap:drawLayer(gameMap.layers["ground"])
    gameMap:drawLayer(gameMap.layers["shadows"])
    gameMap:drawLayer(gameMap.layers["behind-the-wall"])
    gameMap:drawLayer(gameMap.layers["upper-wall"])
    gameMap:drawLayer(gameMap.layers["stairs-shadow"])
    gameMap:drawLayer(gameMap.layers["runes"])
    gameMap:drawLayer(gameMap.layers["deco"])
    gameMap:drawLayer(gameMap.layers["bottom-wall-back"])
    gameMap:drawLayer(gameMap.layers["level-2-runes"])
    gameMap:drawLayer(gameMap.layers["level-2-shadows"])
    gameMap:drawLayer(gameMap.layers["deco-level-2"])
    gameMap:drawLayer(gameMap.layers["rock-tile"])

    racoonRender()
    playerRender()

    gameMap:drawLayer(gameMap.layers["bottom-wall-front"])
    gameMap:drawLayer(gameMap.layers["stairs-to-level-2"])
    gameMap:drawLayer(gameMap.layers["nature"])

end