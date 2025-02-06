require "scripts/dialogues"

function loadRunes() 
    runes = {}
    if gameMap.layers["rune_obj"] then
        for i, obj in pairs(gameMap.layers["rune_obj"].objects) do
            local rune = {}
            rune.x = obj.x
            rune.y = obj.y
            rune.idx = obj.name
            rune.mssg = runeMessages[rune.idx]
            table.insert(runes, rune)
        end
    end
end