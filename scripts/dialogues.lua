LoveDialogue = require "lib/Love-Dialogue-main/LoveDialogue"
racTextBox = false

runeSFX = love.audio.newSource("rsc/sounds/runeSFX.mp3", "static")
typingSFX = love.audio.newSource("rsc/sounds/coinSFX.mp3", "static")

racDialogue = LoveDialogue.play("rsc/dialogues/rac.ld")
runeMssg1 = LoveDialogue.play("rsc/dialogues/rune1.ld")
runeMssg2 = LoveDialogue.play("rsc/dialogues/rune2.ld")
runeMssg3 = LoveDialogue.play("rsc/dialogues/rune3.ld")
runeMssg4 = LoveDialogue.play("rsc/dialogues/rune4.ld")
runeMssg5 = LoveDialogue.play("rsc/dialogues/rune5.ld")
runeMssg6 = LoveDialogue.play("rsc/dialogues/rune6.ld")

allDialogue = {racDialogue, runeMssg1, runeMssg2, runeMssg3, runeMssg4, runeMssg5, runeMssg6, FinaleDialogue}

runeMessages = {
    ["1"] = {runeMssg1, false},
    ["2"] = {runeMssg2, false},
    ["3"] = {runeMssg3, false},
    ["4"] = {runeMssg4, false},
    ["5"] = {runeMssg5, false},
    ["6"] = {runeMssg6, false}
}

function updateDialogues(dt) 
    for i, obj in pairs(allDialogue) do 
        obj:update(dt)
    end
end

function drawDialogues() 
    for i, obj in pairs(runeMessages) do 
        if runeMessages[i][2] then
            runeMessages[i][1]:draw()
        end
    end

    if racTextBox or win_con then
        racDialogue:draw()
    end
end

function interactionModules()
    -- Rac
    if calculateDistance(player, rac) < 230 then
        if racDialogue.currentLine ~= 7 then
        racTextBox = not racTextBox
        typingSFX:play()
        end
    else
    -- Runes
        for i, obj in pairs(runes) do
            if calculateDistance(player, obj) < 80 then
                if not runeMessages[obj.idx][2] then
                    runeSFX:play()
                end
                runeMessages[obj.idx][2] = not runeMessages[obj.idx][2]
                break
            end
        end
    end
end