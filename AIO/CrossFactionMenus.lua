local AIO = AIO or require("AIO")

if AIO.AddAddon() then
   return
end

CrossFactionMenu = {};
CrossFactionMenu.Macros = {};

function CrossFactionMenu.Macros.onLoad()
    CrossFactionMenu.Macros.menuItems = {};

    UnitPopupButtons["CrossFactionMenu_Invite"] = { text = "Invite", dist = 0 };
    table.insert(CrossFactionMenu.Macros.menuItems, "Invite");

    UnitPopupButtons["CrossFactionMenu_Whisper"] = { text = "Whisper", dist = 0 };
    table.insert(CrossFactionMenu.Macros.menuItems, "Whisper");

    UnitPopupButtons["CrossFactionMenu_Follow"] = { text = "Follow", dist = 0 };
    table.insert(CrossFactionMenu.Macros.menuItems, "Follow");

    UnitPopupButtons["CrossFactionMenu_Trade"] = { text = "Trade", dist = 0 };
    table.insert(CrossFactionMenu.Macros.menuItems, "Trade");

    hooksecurefunc("UnitPopup_OnClick", CrossFactionMenu.Macros.contextMenuClick);
end

function CrossFactionMenu.Macros.contextMenuClick(self)
    local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
    local button = self.value;
    local name = dropdownFrame.name;
    local startPos = string.find(button, "CrossFactionMenu_");

    --print("Context menu clicked for button: " .. button);

    if (startPos == 1) then
        -- Adjusted to extract correctly
        button = string.sub(button, startPos + #("CrossFactionMenu_"));  -- Get the substring correctly
        --print("Action identified: " .. button);

        if button == "Invite" then
            CrossFactionMenu.Macros.invite(name);
        elseif button == "Follow" then
            CrossFactionMenu.Macros.follow(name);
        elseif button == "Trade" then
            CrossFactionMenu.Macros.trade(name);
        elseif button == "Whisper" then
            CrossFactionMenu.Macros.whisper(name);
        end
    end

    CloseDropDownMenus();
end

local lastInteractTime = 0

function CrossFactionMenu.Macros.invite(name)
    local currentTime = GetTime()
    if currentTime - lastInteractTime >= 0.1 then
        --print("Inviting: " .. name);
        InviteUnit(name);
        lastInteractTime = currentTime
    end
end

function CrossFactionMenu.Macros.whisper(name)
    if name and name ~= "" then
        local editBox = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(editBox)
        editBox:SetText("/w " .. name .. " ")
        editBox:HighlightText()
    end
end

function CrossFactionMenu.Macros.follow(name)
    local currentTime = GetTime()
    if currentTime - lastInteractTime >= 0.1 then
        UIErrorsFrame:AddMessage("You need to be in a group with this player to follow them.", 1.0, 0.1, 0.1, 1.0);
        lastInteractTime = currentTime
    end
end

function CrossFactionMenu.Macros.trade(name)
    local currentTime = GetTime()
    if currentTime - lastInteractTime >= 0.1 then
        UIErrorsFrame:AddMessage("You need to be in a group with this player to trade them.", 1.0, 0.1, 0.1, 1.0);
        lastInteractTime = currentTime
    end
end

function CrossFactionMenu.Macros.updateMenu()
    local targetName = UnitName("target")
    local playerFaction = UnitFactionGroup("player")
    local targetFaction = UnitFactionGroup("target")
    local isInGroup = UnitInParty("target") or UnitInRaid("target")

    -- First, clean up existing menu items
    for _, menu in pairs(UnitPopupMenus) do
        for i = #menu, 1, -1 do
            if string.find(menu[i], "CrossFactionMenu_") then
                table.remove(menu, i)
            end
        end
    end

    local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
    if dropdownFrame and dropdownFrame.which == "CHAT" then
        return
    end

    if targetName and playerFaction and targetFaction and 
       playerFaction ~= targetFaction and 
       not isInGroup then
        -- Add non-whisper buttons
        for _, button in ipairs(CrossFactionMenu.Macros.menuItems) do
            if button ~= "Whisper" then
                table.insert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"] - 1, "CrossFactionMenu_" .. button);
                table.insert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "CrossFactionMenu_" .. button);
                table.insert(UnitPopupMenus["PARTY"], #UnitPopupMenus["PARTY"] - 1, "CrossFactionMenu_" .. button);
                table.insert(UnitPopupMenus["RAID_PLAYER"], #UnitPopupMenus["RAID_PLAYER"] - 1, "CrossFactionMenu_" .. button);
                table.insert(UnitPopupMenus["TEAM"], #UnitPopupMenus["TEAM"] - 1, "CrossFactionMenu_" .. button);
                table.insert(UnitPopupMenus["CHAT_ROSTER"], #UnitPopupMenus["CHAT_ROSTER"] - 1, "CrossFactionMenu_" .. button);
            end
        end

        -- Add whisper button
        table.insert(UnitPopupMenus["PLAYER"], 2, "CrossFactionMenu_Whisper");
        table.insert(UnitPopupMenus["FRIEND"], 2, "CrossFactionMenu_Whisper");
        table.insert(UnitPopupMenus["PARTY"], 2, "CrossFactionMenu_Whisper");
        table.insert(UnitPopupMenus["RAID_PLAYER"], 2, "CrossFactionMenu_Whisper");
        table.insert(UnitPopupMenus["TEAM"], 2, "CrossFactionMenu_Whisper");
    end
end


-- Crossfaction Menus frame
CrossFactionMenu.Macros.onLoad();
local f = CreateFrame("Frame")
f:RegisterEvent("RAID_MEMBERS_CHANGED")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("PARTY_MEMBERS_CHANGED")
f:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_TARGETCHANGED" then
        CrossFactionMenu.Macros.updateMenu();
    else
        local targetName = UnitName("target")
        if not targetName then return end

        -- Create timer frame
        local timerFrame = CreateFrame("Frame")
        timerFrame.elapsed = 0
        timerFrame:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            if self.elapsed >= 0.05 then -- 50ms
                local isInGroup = UnitInParty("target") or UnitInRaid("target")
                local playerFaction = UnitFactionGroup("player")
                local targetFaction = UnitFactionGroup("target")

                if playerFaction ~= targetFaction then
                    if isInGroup then
                        for _, menu in pairs(UnitPopupMenus) do
                            for i = #menu, 1, -1 do
                                if string.find(menu[i], "CrossFactionMenu_") then
                                    table.remove(menu, i)
                                end
                            end
                        end
                    else
                        CrossFactionMenu.Macros.updateMenu()
                    end
                else
                    CrossFactionMenu.Macros.updateMenu()
                end
                self:SetScript("OnUpdate", nil) -- Clean up timer
            end
        end)
    end
end)
