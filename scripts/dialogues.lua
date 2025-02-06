LoveDialogue = require "lib/Love-Dialogue-main/LoveDialogue"
racTextBox = false

runeMessages = {
    ["1"] = runeMssg1,
    ["2"] = runeMssg2,
    ["3"] = runeMssg3,
    ["4"] = runeMssg4,
    ["5"] = runeMssg5,
    ["6"] = runeMssg6
}

function setUpDialogues() 
    myDialogue = LoveDialogue.play("rsc/dialogues/rac.ld")
    runeMssg1 = LoveDialogue.play("rsc/dialogues/rune1.ld")
    runeMssg2 = LoveDialogue.play("rsc/dialogues/rune2.ld")
    runeMssg3 = LoveDialogue.play("rsc/dialogues/rune3.ld")
    runeMssg4 = LoveDialogue.play("rsc/dialogues/rune4.ld")
    runeMssg5 = LoveDialogue.play("rsc/dialogues/rune5.ld")
    runeMssg6 = LoveDialogue.play("rsc/dialogues/rune6.ld")
    FinaleDialogue = LoveDialogue.play("rsc/dialogues/rac_final.ld")

    allDialogue = {myDialogue, runeMssg1, runeMssg2, runeMssg3, runeMssg4, runeMssg5, runeMssg6, FinaleDialogue}

end

function updateDialogues(dt) 
    for i, obj in pairs(allDialogue) do 
        obj:update(dt)
    end
end

function drawDialogues() 
    if showRune1 then 
        runeMssg1:draw()
    end

    if showRune2 then
        runeMssg2:draw()
    end

    if racTextBox then
        myDialogue:draw()
    end

    if showRune3 then 
        runeMssg3:draw()
    end

    if showRune4 then 
        runeMssg4:draw()
    end

    if showRune5 then 
        runeMssg5:draw()
    end
    if showRune6 then 
        runeMssg6:draw()
    end
    if win_con then
        myDialogue:draw()
    end
end

function interactionModules() 
    if calculateDistance(player, rac) < 230 then
        if racTextBox then 
            rac.dialogue1.isActive = not rac.dialogue1.isActive
        end
        racTextBox = true
    end

    for i, obj in pairs(runes) do
        if calculateDistance(player, obj) < 80 then
            if obj.idx == "1" then
                if showRune1 then
                    runeMssg1.isActive = not runeMssg1.isActive
                end
                showRune1 = true
            end

            if obj.idx == "2" then
                if showRune2 then 
                    runeMssg2.isActive = not runeMssg2.isActive
                end
                showRune2 = true
            end

            if obj.idx == "3" then
                if showRune3 then 
                    runeMssg3.isActive = not runeMssg3.isActive
                end
                showRune3 = true
            end

            if obj.idx == "4" then
                if showRune4 then 
                    runeMssg4.isActive = not runeMssg4.isActive
                end
                showRune4 = true
            end

            if obj.idx == "5" then
                if showRune5 then 
                    runeMssg5.isActive = not runeMssg5.isActive
                end
                showRune5 = true
            end

            if obj.idx == "6" then
                if showRune6 then 
                    runeMssg6.isActive = not runeMssg6.isActive
                end
                showRune6 = true
            end
        end
    end
end