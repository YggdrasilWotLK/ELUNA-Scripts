-- This ELUNA module sets the faction of all players in an instance to the same as the first player to enter it.
-- Written by mostly nick :) for Yggdrasil WoW

local cachedFaction = {}

local function OnPlayerMapChange(event, player)
    local instanceId = player:GetInstanceId()
    
    if instanceId and instanceId > 0 then
        if not cachedFaction[instanceId] then
            for _, otherPlayer in pairs(GetPlayersInWorld()) do
                if otherPlayer:GetInstanceId() == instanceId and player:GetGUIDLow() ~= otherPlayer:GetGUIDLow() then
                    cachedFaction[instanceId] = otherPlayer:GetFaction()
					print(player:GetFaction())
					if player:GetFaction() ~= cachedFaction[instanceId] then
						if (cachedFaction[instance] == 2
						or cachedFaction[instance] == 5
						or cachedFaction[instance] == 6
						or cachedFaction[instance] == 9
						or cachedFaction[instance] == 116
						or cachedFaction[instance] == 914
						or cachedFaction[instance] == 1610)
						and 
						not (player:GetFaction() == 2
						or player:GetFaction() == 5 
						or player:GetFaction() == 6 
						or player:GetFaction() == 9 
						or player:GetFaction() == 116
						or player:GetFaction() == 914 
						or player:GetFaction() == 1610)
						then
							player:SendAreaTriggerMessage("Your have entered an active Horde instance. Your faction has been set to the Horde.")
						else
							player:SendAreaTriggerMessage("Your have entered an active Alliance instance. Your faction has been set to the Alliance.")
						end
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
				if (cachedFaction[instance] == 2
				or cachedFaction[instance] == 5
				or cachedFaction[instance] == 6
				or cachedFaction[instance] == 9
				or cachedFaction[instance] == 116
				or cachedFaction[instance] == 914
				or cachedFaction[instance] == 1610)
				and 
				not (player:GetFaction() == 2
				or player:GetFaction() == 5 
				or player:GetFaction() == 6 
				or player:GetFaction() == 9 
				or player:GetFaction() == 116
				or player:GetFaction() == 914 
				or player:GetFaction() == 1610)
				then
					player:SendAreaTriggerMessage("Your have entered an active Horde instance. Your faction has been set to the Horde.")
				else
					player:SendAreaTriggerMessage("Your have entered an active Alliance instance. Your faction has been set to the Alliance.")
				end
				print(player:GetFaction())
				player:SetFaction(cachedFaction[instanceId])
			end
        end

    else
		oldFaction = player:GetFaction()
        player:SetFactionForRace(player:GetRace())
		newFaction = player:GetFaction()
		--if oldFaction ~= newFaction then
		--	player:SendAreaTriggerMessage("Your faction ID has been set from ID "..oldFaction.." to "..newFaction)
		--end
		print(player:GetFaction())
    end
end

RegisterPlayerEvent(28, OnPlayerMapChange)
print("[Instance]: Neutral Faction Instance module loaded!")
