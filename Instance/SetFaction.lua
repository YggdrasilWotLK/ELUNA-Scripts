-- This ELUNA module sets the faction of all players in an instance to the same as the first player to enter it.
-- Written by mostly nick :) for Yggdrasil WoW

local cachedFaction = {}

local function OnPlayerMapChange(event, player)
    local instanceId = player:GetInstanceId()
    
    if instanceId and instanceId > 0 then
        if not cachedFaction[instanceId] then
            for _, otherPlayer in pairs(GetPlayersInWorld()) do
                if otherPlayer:GetInstanceId() == instanceId and player:GetGUIDLow() ~= otherPlayer:GetGUIDLow() then -- Builds cache if there is none, in the event of an ELUNA reload
                    cachedFaction[instanceId] = otherPlayer:GetFaction()
                    if player:GetFaction() ~= cachedFaction[instanceId] then
                        player:SetFaction(cachedFaction[instanceId])
                    end
                    break
                end
            end
            
            if not cachedFaction[instanceId] then
                cachedFaction[instanceId] = player:GetFaction()
            end
        else
            if player:GetFaction() ~= cachedFaction[instanceId] then
                player:SetFaction(cachedFaction[instanceId])
            end
        end

    else
        player:SetFactionForRace(player:GetRace())
    end
end

RegisterPlayerEvent(28, OnPlayerMapChange)
print("[Instance]: Neutral Faction Instance module loaded!")
