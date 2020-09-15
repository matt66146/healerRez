function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


HealingSpellName = function(i)
    className, classFilename, classId = UnitClass("player")
    -- Pally
    if classId == 2 then
        return "Redemption"
    end
    -- Priest
    if classId == 5 then
        return "Resurrection"
    end
    -- Shammy
    if classId == 7 then
        return "Ancestral Spirit"
    end
end



btn = CreateFrame("Button", "myButton", UIParent, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate")



local function OnEvent(self, event, prefix, message, channel, sender)
    if event == "CHAT_MSG_ADDON" then
        if prefix == "mattrez" then
            deadGuy = split(message,",")
            --print(message)
            --print(deadGuy[1])
            --print(deadGuy[2])
            CreateButton(deadGuy[1], deadGuy[2])
        end
    end

end

C_ChatInfo.RegisterAddonMessagePrefix("mattrez")
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)


rId = ""
CreateButton = function(d, r)
    rId = r
    btn:SetSize(50,50)
    btn:SetPoint("CENTER", 0,0)
    btn:SetAttribute("type", "macro");
    --print(HealingSpellName())
    local macro = "/target " .. d.. "\n/cast " .. HealingSpellName()
    btn:SetAttribute("macrotext", macro)
    --print(macro)

    btn:Show();
    C_Timer.After(5, HideButton);
end


HideButton = function()
    if UnitIsDeadOrGhost(rId) then
        --print("Player still dead waiting...")
        C_Timer.After(5, HideButton);
    else
        print("Hiding button")
        btn:Hide();
    end
end

