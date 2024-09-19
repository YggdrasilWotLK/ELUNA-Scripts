-- Mostly nick :)'s fix for missing animations and broken pathing on quest 13297

local function OnSpawn(event, creature)
    local entry = creature:GetEntry()
    
    if entry == 32181 then
        local choice = math.random(1, 3)
        if choice == 1 then
			creature:NearTeleport(6761 + math.random(0, 3), 1567 + math.random(-2, 2), 394.55, 0.6)
			creature:SetHomePosition(6761 + math.random(0, 3), 1567 + math.random(-2, 2), 394.55, 0.6)
		elseif choice == 2 then
			creature:NearTeleport(6771 + math.random(-2, 2), 1584 + math.random(-2, 2), 389, 6.2)
			creature:SetHomePosition(6771 + math.random(-2, 2), 1584 + math.random(-2, 2), 389, 6.2)
		else
			creature:NearTeleport(6761+ math.random(-2, 2), 1603 + math.random(-2, 2), 389.03, 5.79)
			creature:SetHomePosition(6761 + math.random(-2, 2), 1603 + math.random(-2, 2), 389.03, 5.79)
        end
    elseif entry == 32178 or entry == 32176 then
		creature:PerformEmote(449) -- Crawl animation
		creature:SetHomePosition(6766 + math.random(-2, 2), 1584 + math.random(-2, 2), 389, 6.2)
		creature:RegisterEvent(function(eventId, delay, repeats, creature)
			local player = creature:GetNearestPlayer(30)
			if player then
				creature:CastSpell(player, 70150, true)
			else
				creature:NearTeleport(6766 + math.random(-2, 2), 1584 + math.random(-2, 2), 389, 6.2)
			end
			creature:RemoveEvents()
		end, 3000, 1)
    end
end

RegisterCreatureEvent(32181, 5, OnSpawn)
RegisterCreatureEvent(32178, 5, OnSpawn)
RegisterCreatureEvent(32176, 5, OnSpawn)
