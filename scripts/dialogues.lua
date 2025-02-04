function advanceDialogue(condition, dialogueObject)
    if condition then 
        dialogueObject.isActive = not dialogueObject.isActive
        dialogueObject.currentLine = 1
        return true
    end
    return true
end


--[[if calculateDistance(player, obj) < 200 then
    if obj.idx == "1" then
        if test1 then 
            mySecondDialogue.isActive = not mySecondDialogue.isActive
            mySecondDialogue.currentLine = 1
        end
        test1 = true
    end
end]]