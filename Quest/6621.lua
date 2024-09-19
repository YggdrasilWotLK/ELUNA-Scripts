-- ELUNA correction for pathing on quest 6621 foulweald. Author: mostly nick :)

local QUEST_ID = 6621
local CHECK_RANGE = 100

local function OnSpawn(event, creature)
    --print("Creature with ID "..creature:GetEntry().." spawned!")
    
	local players = creature:GetPlayersInRange(CHECK_RANGE)
    if players then
        print("Player found!")
        for _, player in ipairs(players) do
            if player:IsAlive() and player:HasQuest(QUEST_ID) then
				creature:SetSpeed(1, 0.6)
				creature:MoveTo(1, 2230, -1551, 93.07, true)
				--print("Player found, creature moving to coordinates: 2230, -1551, 93.07")
                return
            end
        end
    end
    
    --print("No eligible players present! Despawning NPC.")
    creature:DespawnOrUnsummon()
end

RegisterCreatureEvent(12921, 5, OnSpawn)
RegisterCreatureEvent(12918, 5, OnSpawn)
--print("[Quest Fix 6621]: Foulweald quest fix loaded!")
