local oachanoaevent
local oachanoaeventplayer
local repeatcount

local function CompletionEvent(player)
	print("[Oacha'noa ELUNA]: Checking for quest completion...")
    if player and (player:GetZ() < 50 and player:IsFalling() or player:IsInWater() and not (player:GetQuestStatus(12032) == 1)) then -- check for quest status too
  
        local oachanoa = player:GetNearestCreature(200, 26648)
        if oachanoa and not (player:GetQuestStatus(12032) == 1) and not (player:GetQuestStatus(12032) == 5) then
		
			player:SendAreaTriggerMessage("Oacha'noa's compulsion obeyed. (Complete)") --Completion message (yellow, not localized)
			player:CompleteQuest(12032) -- Sets quest status to 1
			repeatcount = 15
			
			
			oachanoa:PerformEmote(33)
			oachanoa:PlayDistanceSound(11558)
            oachanoa:SendUnitYell("Well done, " .. oachanoaeventplayer .. ". Your display of respect is duly noted. Now, I have information for you that you must convey to the Kalu'ak.", 0)
			
			oachanoa:RegisterEvent(function(eventId, delay, repeats, oachanoa) --First whisper
				player = GetPlayerByName(oachanoaeventplayer)
				oachanoa:SendUnitWhisper("Simply put, you must tell the tuskarr that they cannot run. If they do so, their spirits will be destroyed by the evil rising within Northrend.", 0, player)
			end, 10000, 1)
			
			oachanoa:RegisterEvent(function(eventId, delay, repeats, oachanoa) --Second whisper
				player = GetPlayerByName(oachanoaeventplayer)
				oachanoa:SendUnitWhisper("Tell the mystic that his people are to stand and fight alongside the Horde and Alliance against the forces of Malygos and the Lich King.", 0, player)
			end, 20500, 1)
			
			oachanoa:RegisterEvent(function(eventId, delay, repeats, oachanoa) --Last whisper
				player = GetPlayerByName(oachanoaeventplayer)
				if player then
					oachanoa:SendUnitWhisper("Now swim back with the knowledge I have granted you. Do what you can for them, "..player:GetRaceAsString()..".", 0, player)
					oachanoaevent = nil
					oachanoaeventplayer = nil
					repeatcount = nil
					player:AddAura(41273, player)
				end
			end, 31000, 1)
			
			oachanoa:RegisterEvent(function(eventId, delay, repeats, oachanoa)
				oachanoa:PerformEmote(374)
				oachanoa:PlayDistanceSound(11561)
				oachanoa:DespawnOrUnsummon(2300)
				oachanoa:NearTeleport(oachanoa:GetX(), oachanoa:GetY(), oachanoa:GetZ(), -5)
				oachanoa:RemoveEvents()
			end, 39000, 1)
		end
    end
end

local function PearloftheDepthsUse(event, go, player)
	print("[Oacha'noa ELUNA]: Gameobject 188422 used!")
	
	if oachanoaevent == true then
		print("[Oacha'noa ELUNA]: Oacha'noa event active, skipping gameobject-related events...")
		return
	elseif (player:GetQuestStatus(12032) == 3) then
		print("[Oacha'noa ELUNA]: Starting Oacha'noa quest event!")
		
		oachanoaevent = true
		oachanoaeventplayer = player:GetName()
		
		trigger = go:GetNearestCreature(100, 70100)
		trigger:CastSpell(trigger, 30254, true)

		go:RegisterEvent(function(eventId, delay, repeats, go)
			oachanoa = go:SpawnCreature(26648, 2272, 1665, 20, 0.23, 1, 90000)
		end, 20000, 1)
		
		go:RegisterEvent(function(eventId, delay, repeats, go)
			oachanoa = go:GetNearestCreature(400, 26648)
			if oachanoa then
				oachanoa:SetDisableGravity(true)
				oachanoa:SetSpeed(3,4)
				oachanoa:MoveTo(99999, 2380.123, 1690.68, 40, false)
				print("[Oacha'noa ELUNA]: Moving Oacha'noa to event area...")
			end
		end, 20020, 1)
		
		go:RegisterEvent(function(eventId, delay, repeats, go)
			oachanoa = go:GetNearestCreature(200, 26648)
			if oachanoa then
				oachanoa:PerformEmote(33)
				oachanoa:PlayDistanceSound(11558)
				oachanoa:SendUnitYell("Little "..oachanoaeventplayer..", why do you call me forth? Are you working with the trolls of this land? Have you come to kill me and take my power as your own?", 0)
			end
		end, 27000, 1)
		
		go:RegisterEvent(function(eventId, delay, repeats, go)
			oachanoa = go:GetNearestCreature(200, 26648)
			if oachanoa then
				oachanoa:PerformEmote(33)
				oachanoa:PlayDistanceSound(11558)
				oachanoa:SendUnitYell("I sense uncertainty in you, and I do not trust it whether you are with them, or not. If you wish my augury for the Kalu'ak, you will have to prove yourself first.", 0)
			end
		end, 36000, 1)
		
		go:RegisterEvent(function(eventId, delay, repeats, go)
			oachanoa = go:GetNearestCreature(200, 26648)
			if oachanoa then
				oachanoa:PerformEmote(33)
				oachanoa:PlayDistanceSound(11558)
				oachanoa:SendUnitYell("I will lay a mild compulsion upon you. Jump into the depths before me so that you put yourself into my element and thereby display your submission.", 0)
			end
			
			player = GetPlayerByName(oachanoaeventplayer) -- Retrieving player in new sub-function
			
			if player and go:GetDistance(player) < 80 and player:GetZ() > 50 then -- Verifying player existence and location
			
				player:AddAura(47098, player) -- Completion event start
				
				player:RegisterEvent(function(eventId, delay, repeats, player)
					CompletionEvent(player)
					if not repeatcount then
						repeatcount = 1
					elseif repeatcount == 15 then
						player:RemoveEventById(eventId)
						repeatcount = nil
						print("[Oacha'noa ELUNA]: Completion check event and repeat count removed!")
					else 
						repeatcount = repeatcount + 1
					end
				end, 2000, 15)
				
				player:RegisterEvent(function(eventId, delay, repeats, player)
					if player:GetZ() > 53 then
						oachanoa = player:GetNearestCreature(200, 26648)
						if oachanoa then
							oachanoa:PerformEmote(33)
							oachanoa:PlayDistanceSound(11558)
							oachanoa:SendUnitYell("Though you are compelled, the choice, and the last step before you leap, are yours. You have twenty more seconds to decide.", 0)
						end
					end
					player:RemoveEventById(eventId)
				end, 10000, 1)
				
				player:RegisterEvent(function(eventId, delay, repeats, player)
					oachanoa = player:GetNearestCreature(200, 26648)
					
					if oachanoa and not (player:GetQuestStatus(12032) == 1) then
						player:FailQuest(12032)
						player:SendAreaTriggerMessage("Oacha'noa's compulsion obeyed. (Failed)") -- Center screen failed message (yellow, not localized)
						
						oachanoa:PerformEmote(33)
						oachanoa:PlayDistanceSound(11558)
						oachanoa:SendUnitYell(" Very well, "..oachanoaeventplayer..", you have failed to act. The prophecy is not yours to learn. Do not call upon me again until you have found your backbone!", 0)
						
						oachanoa:RegisterEvent(function(eventId, delay, repeats, oachanoa)
							oachanoa:PerformEmote(374)
							oachanoa:PlayDistanceSound(11561)
							oachanoa:DespawnOrUnsummon(2300)
							oachanoa:NearTeleport(oachanoa:GetX(), oachanoa:GetY(), oachanoa:GetZ(), -5)
						end, 10000, 1)
						
						oachanoaeventplayer = nil
						oachanoaevent = nil
						repeatcount = nil
					end
					
					player:RemoveEventById(eventId)
				end, 32100, 1)
				
			end
		end, 47000, 1)
			
		go:RegisterEvent(function(eventId, delay, repeats, go) -- Resets cache, object and events for next player
			oachanoaevent = nil
			oachanoaeventplayer = nil
			repeatcount = nil
			go:RemoveEvents()
		end, 124000, 1)
	end
	return false
end

RegisterGameObjectEvent(188422, 14, PearloftheDepthsUse)

WorldDBExecute("UPDATE gameobject_template SET ScriptName = '' WHERE entry = 188422;")
