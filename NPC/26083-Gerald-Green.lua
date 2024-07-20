-- Makes Gerald Green return home after he gets lost. Only checks when players enter Farshire, max once per minute
-- Made by mostly nick :)

local NPC_ID = 26083
local HOME_X = 2484
local HOME_Y = 5217
local HOME_Z = 31.7
local HOME_O = 0.27
local AREA = 4111
local MAX_DISTANCE = 15
local lastExecutionTime = 0

local function OnPlayerEnterArea(event, player, newZone, newArea)
    if newArea == AREA then
        local currentTime = os.time()
        if currentTime - lastExecutionTime < 60 then
            return -- Exit the function if less than a minute has passed
        end
        lastExecutionTime = currentTime

        --print("[NPC]: Gerald Green - Player entered area!")
        local creature = player:GetNearestCreature(200, NPC_ID)  -- Adjust range as needed
        creature:SetHomePosition(HOME_X, HOME_Y, HOME_Z, HOME_O)
        local currentX, currentY, currentZ = creature:GetX(), creature:GetY(), creature:GetZ()
        local distance = creature:GetDistance(HOME_X, HOME_Y, HOME_Z)
    
        if distance > MAX_DISTANCE then
            print("[NPC]: Gerald Green - Player present and NPC is too far from home. Returning to original position.")
            creature:MoveHome()
        --else
            --print("Player present and NPC is within allowed range.")
        end
    end
end

-- Register the event to trigger when a player enters a new area
RegisterPlayerEvent(27, OnPlayerEnterArea)
print("[NPC]: Gerald Green positioning loaded!")
