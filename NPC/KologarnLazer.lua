-- moslty nick :)'s ELUNA fix for Kologarn's cross-eyed still-standing lazers on stock AzerothCore

local function LazerSpawn(event, creature)
	
	if creature:GetEntry() == 33802 then -- Sets original position to ensure lazers are in range of Kologarn and players
		creature:NearTeleport(1767, -23, 448.80, 0)
	else
		creature:NearTeleport(1770, -28, 448.80, 0)
	end
	
    local kologarn = creature:GetNearestCreature(60, 32930) -- Find the nearest creature with entry ID 32930 (Kologarn), later used to find player

    local playersInRange = kologarn:GetPlayersInRange(54, 1, 1) -- Get all players in range of Kologarn
    
    -- Initialize a variable to store the player farthest from Kologarn
    local maxrangeplayer = nil
    local maxDistance = 0
    
    -- Loop through all players in range to find the farthest one
    for _, player in pairs(playersInRange) do
        local distance = player:GetDistance(kologarn)
        if distance > maxDistance then
            maxDistance = distance
            maxrangeplayer = player
		end
    end
	
	if maxrangeplayer == nil then maxrangeplayer = creature:GetNearestPlayer(30) end -- If no players in LOS of Kolagarn (happens if they stand on edge)
	
	if creature:GetEntry() == 33802 then -- Move lazers to farthest player
		if maxrangeplayer:GetDistance(1771, -24, 448) < 23 and maxrangeplayer:GetX() < 1785 then
			creature:NearTeleport(maxrangeplayer:GetX()-1, maxrangeplayer:GetY()-3, maxrangeplayer:GetZ(), maxrangeplayer:GetO())
			creature:SetHomePosition(maxrangeplayer:GetX()-1, maxrangeplayer:GetY()-3, maxrangeplayer:GetZ(), maxrangeplayer:GetO())
		else
			creature:NearTeleport(maxrangeplayer:GetX(), maxrangeplayer:GetY(), maxrangeplayer:GetZ(), maxrangeplayer:GetO())
			creature:SetHomePosition(maxrangeplayer:GetX(), maxrangeplayer:GetY(), maxrangeplayer:GetZ(), maxrangeplayer:GetO())
		end
	else
		if maxrangeplayer:GetDistance(1771, -24, 448) < 23 and maxrangeplayer:GetX() < 1785 then
			creature:NearTeleport(maxrangeplayer:GetX()+1, maxrangeplayer:GetY()+3, maxrangeplayer:GetZ(), maxrangeplayer:GetO())
			creature:SetHomePosition(maxrangeplayer:GetX()+1, maxrangeplayer:GetY()+3, maxrangeplayer:GetZ(), maxrangeplayer:GetO())
		else
			creature:NearTeleport(maxrangeplayer:GetX(), maxrangeplayer:GetY(), maxrangeplayer:GetZ(), maxrangeplayer:GetO())
			creature:SetHomePosition(maxrangeplayer:GetX(), maxrangeplayer:GetY(), maxrangeplayer:GetZ(), maxrangeplayer:GetO())
		end
	end
	
    if maxrangeplayer then  -- If a player is found, make the lazer follow the farthest player
		creature:SetInCombatWith(maxrangeplayer)
		creature:SetSpeed(0, 0.7)
		creature:SetSpeed(1, 0.7)
		
		if creature:GetEntry() == 33802 then
			creature:MoveFollow(maxrangeplayer, 1, 0.3)
		else
			creature:MoveFollow(maxrangeplayer, 1, -2.1)
		end
		
		creature:RegisterEvent(function(eventId, delay, repeats, creature)
			player = creature:GetNearestPlayer(50)
			if player:GetDifficulty() == 1 then
				creature:AddAura(63977, creature) -- 25-man eye AOE
			else
				creature:AddAura(63347, creature) -- 10-man eye AOE
			end
			
			if creature:GetEntry() == 33802 then
				creature:CastSpell(creature, 63702, true) -- Right beam
			else
				creature:CastSpell(creature, 63676, true) -- Left beam
			end
			
			creature:RemoveEventById(eventId) -- Clean up event in case NPC janks out and stays inactive
			
		end, 20, 1)
			
    end
end

-- Register the event for lazer NPCs
RegisterCreatureEvent(33802, 5, LazerSpawn)
RegisterCreatureEvent(33632, 5, LazerSpawn)
