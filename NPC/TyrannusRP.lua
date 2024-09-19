-- mostly nick :)'s Tyrannus RP fix for AzerothCore, to be used in combination with https://github.com/azerothcore/azerothcore-wotlk/pull/15931

local function POSCombat(event, player, enemy)
	if enemy:GetEntry() == 36877 then -- Wrathbone skeletons in cave
		local Tyrannus = player:GetNearestCreature(150, 36658, 0, 1)
		local Rimefang = player:GetNearestCreature(150, 36661)
		
		if Tyrannus and Rimefang and not Rimefang:HasAura(46598) then
			Tyrannus:CastSpell(Rimefang, 46598, true)
		end
	end
	if enemy:GetEntry() == 36658 then -- Tyrannus
	
		player:RegisterEvent(function(eventId, delay, repeats, player)
					
			local slaveGroups = {
			player:GetCreaturesInRange(150, 37572),
			player:GetCreaturesInRange(150, 37575),
			player:GetCreaturesInRange(150, 37576)
			}
				
			for _, group in ipairs(slaveGroups) do
				for _, slave in ipairs(group) do
					slave:SetFaction(1)
				end
			end
			
			player:RemoveEventById(eventId)
			
		end, 5000, 1)
	end
end

RegisterPlayerEvent(33, POSCombat)
print("[Instance]: POS - Tyrannus ally RP and double spawn fix loaded!")
