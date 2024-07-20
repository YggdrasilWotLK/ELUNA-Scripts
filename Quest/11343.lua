-- Completion event on Secrets of Wyrmskull currently missing on AzerothCore. This periodically checks for whether people with quest are in completion event area to mark their quest as completed.
-- Made by mostly nick :)

local AURA_ID = 42786
local QUEST_ID = 11343
local MAP_ID = 571
local AREA_X = 1071
local AREA_Y = -5032
local AREA_Z = 10
local CHECK_INTERVAL = 60 -- Check every 60 seconds
local AREA_RADIUS = 5 -- Radius around the area to check

local function DebugPrint(msg)
    print("[Quest 11343 Fix]: " .. msg)
end

local function CheckPlayersForQuestCompletion()
    --DebugPrint("Checking players for quest completion")
    local players = GetPlayersInWorld()
    for _, player in ipairs(players) do
        if player:HasAura(AURA_ID) then
            local playerMapId = player:GetMapId()
            local distance = player:GetDistance(AREA_X, AREA_Y, AREA_Z)
            --DebugPrint("Checking location of players with aura ID 42876")
            
            if playerMapId == MAP_ID and distance <= AREA_RADIUS then
                if player:HasQuest(QUEST_ID) then
                    DebugPrint("Completing quest ID 11343 for player: " .. player:GetName())
                    player:CompleteQuest(QUEST_ID)
					player:SendAreaTriggerMessage("Secrets of Wyrmskull Uncovered (Complete)") 
                end
            end
		else 
        --    DebugPrint("No players with aura ID 42786 present.")
        end
    end
end

-- Start the global check event
CreateLuaEvent(CheckPlayersForQuestCompletion, CHECK_INTERVAL * 1000, 0)  -- 0 means it will repeat indefinitely
DebugPrint("Secrets of Wrymskull completion event loaded.")
