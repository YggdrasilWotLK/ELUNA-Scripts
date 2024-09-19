-- mostly nick :)'s ELUNA hackfix to circumvent issue where too few friendly adds spawn on Hodir (force respawns Hodir and adds)

local function OnEnterCombat(event, player, enemy)
	if enemy:GetEntry() == 34133 then
		
		print("hodir combat trash ok!")

		local hodir = player:GetNearestCreature(200, 32845)
		
		if not hodir or (hodir and hodir:IsDead()) then
			print("No Hodir detected!")
			return
		else
			print("hodir detected!")
		end

		--local player = enemy:GetNearestPlayer() --used if hooking onto creature combat, but doesn't work with pre-spawned mobs
		--if not player then return end
		
		difficulty = player:GetDifficulty()

		local npcIds = {
			32897, 32901, 32900, 32893, 33326, 33325, 33328, 33327,
			32948, 32941, 32950, 32946, 33330, 33333, 33332, 33331
		}

		local count = 0
		for _, id in ipairs(npcIds) do
			local npc = enemy:GetNearestCreature(200, id)
			if npc and npc:IsAlive() then
				count = count + 1
				print("NPCs detected: " .. count)
			end
		end
			
		if (difficulty == 1 and count < 8) or count < 4 then
			originalrespawntimer = hodir:GetRespawnDelay()
			hodir:SetRespawnDelay(1)
			hodir:DespawnOrUnsummon()
			hodir:SetRespawnDelay(originalrespawntimer)
		end
	end
end

RegisterPlayerEvent(33, OnEnterCombat)
