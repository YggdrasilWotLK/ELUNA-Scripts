-- Refactored Manabonker to not harass players as much
-- Detach from SAI in creature_template and then import this LUA script 
-- Authored by mostly nick :)

local EVENT_INTERVAL_MIN = 5 * 60 * 1000  -- 5 minutes in milliseconds
local EVENT_INTERVAL_MAX = 15 * 60 * 1000 -- 15 minutes in milliseconds
local SPAWN_NPC_ID = 32838
local SPELL_ID_1 = 51347
local SPELL_ID_2 = 61995
local targetplayer

-- Function to handle the event logic
local function BonkTime(eventId, delay, repeats)
    -- Get all players in the world
    local players = GetPlayersInWorld()
    local eligiblePlayers = {}

    -- Find eligible players in Dalaran with Z > 640
    for _, player in pairs(players) do
        if player:GetZoneId() == 4395 and player:GetZ() > 640 then
            table.insert(eligiblePlayers, player)
        end
    end

    -- If there are eligible players, pick one randomly
    if #eligiblePlayers > 0 then
        local randomIndex = math.random(#eligiblePlayers)
        local chosenPlayer = eligiblePlayers[randomIndex]

        -- Spawn NPC
        local npc = chosenPlayer:SpawnCreature(SPAWN_NPC_ID, chosenPlayer:GetX(), chosenPlayer:GetY(), chosenPlayer:GetZ(), chosenPlayer:GetO(), 1, 40000)
        targetplayer = chosenPlayer:GetName()
		
		if npc then
		
			squirrel = npc:GetNearestCreature(200, 1412) -- Hack fix for missing squirrel movements in Dalaran
			if squirrel then
				squirrel:MoveRandom(10)
			end
			
			npc:MoveRandom(10)
			npc:CastSpell(npc, SPELL_ID_1)
			npc:SetSpeed(1, 0.4)
			
			npc:RegisterEvent(function(eventId, delay, repeats, npc)
				chosenPlayer = GetPlayerByName(targetplayer)
				if chosenPlayer then
					npc:MoveFollow(chosenPlayer, 0.2, 2.8)
					if chosenPlayer:IsMounted() then
						npc:SetSpeed(1, chosenPlayer:GetSpeed(1)*0.2)
					else
						npc:SetSpeed(1, 1.6)
					end
				end
			end, 10000, 1)
			
			npc:RegisterEvent(function(eventId, delay, repeats, npc)
				chosenPlayer = GetPlayerByName(targetplayer)
				if chosenPlayer then
					npc:SetRooted(true)
					npc:SendUnitEmote("Minigob Manabonk tickles ".. chosenPlayer:GetName()..".")
					npc:SendUnitSay("Hee hee! Gotcha!", 0)
				end
			end, 12000, 1)
			
			npc:RegisterEvent(function(eventId, delay, repeats, npc)
				chosenPlayer = GetPlayerByName(targetplayer)
				if chosenPlayer then
					npc:EmoteState(11) -- laugh
					npc:SetFaction(900)
				end
			end, 12500, 1)
			
			npc:RegisterEvent(function(eventId, delay, repeats, npc)
				chosenPlayer = GetPlayerByName(targetplayer)
				if chosenPlayer then
					npc:SetRooted(false)
					npc:SetSpeed(0, 2)
					npc:SetSpeed(1, 1.6)
					npc:MoveTo(1, npc:GetX()-5+math.random(3,7), npc:GetY()-5+math.random(3,7), npc:GetZ(), true)
				end
			end, 15000, 1)
			
			npc:RegisterEvent(function(eventId, delay, repeats, npc)
				targetplayer = nil
				if npc:IsAlive() and not npc:IsInCombat() then
					npc:CastSpell(npc, SPELL_ID_2)
					npc:DespawnOrUnsummon(1000)
				end
			end, 21000, 1)
			
        end
    end

    -- Schedule next event
    local nextEventDelay = math.random(EVENT_INTERVAL_MIN, EVENT_INTERVAL_MAX)
    CreateLuaEvent(BonkTime, nextEventDelay, 1)
end

-- Start the initial event
local initialDelay = math.random(EVENT_INTERVAL_MIN, EVENT_INTERVAL_MAX)
CreateLuaEvent(BonkTime, initialDelay, 1)
