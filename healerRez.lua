SLASH_PHRASE1 = "/hrez"
SlashCmdList["PHRASE"] = function(msg)

    -- Only allow raid leaders and assistants to run the addon
    if UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") then
        rezers = {}
        deads = {}
        rezIterator = 0
        deadIterator = 0
        -- Get Dead People
        for i=1,40 do
            if UnitIsDeadOrGhost("raid" .. i) and UnitIsConnected("raid" .. i) then
                table.insert(deads,{name = UnitName("raid" .. i),healer = IsHealer(i), raidId = "raid" .. i})
            end
        end

        -- Sort whether rezzer or not
        table.sort(deads, function (a, b)
            return a.healer and not b.healer
        end)

        --  Get Alive Healers
        for i=1,40 do
            className, classFilename, classId = UnitClass("raid" .. i)
            if not UnitIsDeadOrGhost("raid" .. i) and UnitIsConnected("raid" .. i) then
                if classId == 2 or classId == 5 or classId == 7 then
                    table.insert(rezers,{name = UnitName("raid" .. i),mana = UnitPower("raid" .. i)}) 
                end
            end
        end
        -- Sort by healer mana
        table.sort(rezers, function (a, b)
            return a.mana > b.mana
        end)

        -- Assign rezzes
        iterator = 1
        for _, rezer in pairs(rezers) do
            if deads[iterator] ~= nil then
                SendChatMessage(rezer.name .. " Rez " .. deads[iterator].name, "RAID_WARNING");
                SendChatMessage("Rez " .. deads[iterator].name, "WHISPER", nil, rezer.name);
                C_ChatInfo.SendAddonMessage("mattrez", deads[iterator].name .. "," .. deads[iterator].raidId , "WHISPER", rezer.name)
                iterator = iterator + 1
            end
        end
    end
end 

IsHealer = function(i)
    className, classFilename, classId = UnitClass("raid" .. i)
    return classId == 2 or classId == 5 or classId == 7
end
    