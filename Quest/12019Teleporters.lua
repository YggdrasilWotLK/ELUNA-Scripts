-- After completing Last Rites (quest ID 12019), teleporters become inactive. This activates them for 3 minutes after handing in quest.
-- Made by mostly nick :)

local QUEST_ID = 12019
local CHECK_INTERVAL = 1000 -- 1 second in milliseconds
local CHECK_RANGE = 1 -- Range to check for gameobjects and players
local GAMEOBJECT_ID = 194026 -- The ID of the game object to look for
local AREA_ID = 4128 -- The area ID where we need to check for players
local questCompletedPlayers = {} -- Table to store players who completed the quest

local function CheckPlayersAndTeleport(eventId, delay, repeats)
    for guid, data in pairs(questCompletedPlayers) do
        local player = GetPlayerByGUID(guid)
        if player and player:GetAreaId() == AREA_ID then
            local nearbyObjects = player:GetNearObjects(CHECK_RANGE, 0, GAMEOBJECT_ID)
            for _, gameObject in pairs(nearbyObjects) do
                if gameObject and gameObject:IsInWorld() then
                    print("Checking GameObject ID = " .. gameObject:GetEntry() .. ", GUID = " .. gameObject:GetGUIDLow())
                    local _, _, z = gameObject:GetLocation()
                    if math.abs(z - 473) <= 1 then
                        player:Teleport(571, 3733, 3563, 290.812, 0) -- Teleport to these coordinates if Z is close to 473
                    elseif math.abs(z - 290.78) <= 1 then
                        player:Teleport(571, 3802, 3585, 49.577, 0) -- Teleport to these coordinates if Z is close to 291
                    end
                end
            end
        end
        
        -- Decrease the counter for this player and remove if it reaches 0
        data.eventCount = data.eventCount - 1
        if data.eventCount <= 0 then
            questCompletedPlayers[guid] = nil -- Remove the player from the table
        end
    end
end

local function OnQuestComplete(event, player, quest)
    if quest:GetId() == QUEST_ID then
        local guid = player:GetGUIDLow()
        questCompletedPlayers[guid] = { eventCount = 200 } -- Store the GUID with event count set to 200
        print("[Quest]: Last Rites teleporter fix - Player with ID "..guid.." just completed quest. Activating teleporters!")
        CreateLuaEvent(CheckPlayersAndTeleport, CHECK_INTERVAL, 200)
    end
end

RegisterPlayerEvent(54, OnQuestComplete) -- 54 is PLAYER_EVENT_ON_COMPLETE_QUEST
