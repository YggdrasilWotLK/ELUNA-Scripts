-- This ELUNA module sets the faction of all players in an instance to the same as the first player to enter it.
-- Written by mostly nick :) for Yggdrasil WoW

local cachedRace = {}

local function OnPlayerMapChange(event, player)
    local instanceId = player:GetInstanceId()
    
    if instanceId and instanceId > 0 then
        if not cachedRace[instanceId] then
            for _, otherPlayer in pairs(GetPlayersInWorld()) do
                if otherPlayer:GetInstanceId() == instanceId and player:GetGUIDLow() ~= otherPlayer:GetGUIDLow() then
                    cachedRace[instanceId] = otherPlayer:GetFaction()
                    if (cachedRace[instanceId] == 1 and player:GetFaction() ~= 1) 
                    or (cachedRace[instanceId] == 3 and player:GetFaction() ~= 3) 
                    or (cachedRace[instanceId] == 4 and player:GetFaction() ~= 4) 
                    or (cachedRace[instanceId] == 7 and player:GetFaction() ~= 7) 
                    or (cachedRace[instanceId] == 11 and player:GetFaction() ~= 11) 
                    then
                        player:SendAreaTriggerMessage("You have joined an Alliance instance. Your faction has been set to the Alliance.")
                        
                    elseif (cachedRace[instanceId] == 2 and player:GetFaction() ~= 2)
                    or (cachedRace[instanceId] == 5 and player:GetFaction() ~= 5)
                    or (cachedRace[instanceId] == 6 and player:GetFaction() ~= 6)
                    or (cachedRace[instanceId] == 8 and player:GetFaction() ~= 8)
                    or (cachedRace[instanceId] == 10 and player:GetFaction() ~= 10) 
                    then
                        player:SendAreaTriggerMessage("You have joined a Horde instance. Your faction has been set to the Horde.")
                    end
                    
                    player:SetFaction(otherPlayer:GetFaction())
                    break
                end
            end
            
            if not cachedRace[instanceId] then
                cachedRace[instanceId] = player:GetRace()
                player:SendAreaTriggerMessage("You are the first player in this instance and have set the instance's faction to your own.")
            end
        else
            
            if (cachedRace[instanceId] == 1 and player:GetFaction() ~= 1) 
            or (cachedRace[instanceId] == 3 and player:GetFaction() ~= 3) 
            or (cachedRace[instanceId] == 4 and player:GetFaction() ~= 4) 
            or (cachedRace[instanceId] == 7 and player:GetFaction() ~= 7) 
            or (cachedRace[instanceId] == 11 and player:GetFaction() ~= 11) 
            then
                player:SendAreaTriggerMessage("You have joined an Alliance instance. Your faction has been set to the Alliance.")
                
            elseif (cachedRace[instanceId] == 2 and player:GetFaction() ~= 2)
            or (cachedRace[instanceId] == 5 and player:GetFaction() ~= 5)
            or (cachedRace[instanceId] == 6 and player:GetFaction() ~= 6)
            or (cachedRace[instanceId] == 8 and player:GetFaction() ~= 8)
            or (cachedRace[instanceId] == 10 and player:GetFaction() ~= 10) 
            then
                player:SendAreaTriggerMessage("You have joined a Horde instance. Your faction has been set to the Horde.")
            end
            player:SetFaction(cachedRace[instanceId])
        end

    else
        player:SetFactionForRace(player:GetRace())
    end
end

RegisterPlayerEvent(28, OnPlayerMapChange)
print("[Instance]: Neutral Faction Instance module loaded!")
