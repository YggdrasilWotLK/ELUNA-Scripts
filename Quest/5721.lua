-- RP addition for https://github.com/TrinityCore/TrinityCore/issues/14172
-- Made by mostly nick :)

local creatureIDs = {10947, 10948, 10949, 10950, 10951, 10952, 10953, 10954}
local targetX, targetY, targetZ = 1490, -3678, 81

local function OnCreatureSpawn(event, creature)
    local creatureID = creature:GetEntry()
    
    for _, id in ipairs(creatureIDs) do
        if creatureID == id then
            local randomX = targetX + math.random(-5, 5)
            local randomY = targetY + math.random(-5, 5)
            local randomZ = targetZ
            
            -- Move the creature to the new position to not fight at odd spawn point
            creature:MoveTo(0, randomX, randomY, randomZ)
            
            -- Set the new position as the home position, ensures they don't return to odd spawn point
            creature:SetHomePosition(randomX, randomY, randomZ, 0.33)
            
            if creatureID == 10948 or creatureID == 10949 or creatureID == 10950 then
                creature:MoveRandom(10) -- Roam
            else
                creature:MoveRandom(5) -- Less roam to let friendly NPC roam over hostile NPC area

            end
            break
        end
    end
end

local function OnCreatureLeaveCombat(event, creature)
	if creatureID == 10948 or creatureID == 10949 or creatureID == 10950 then
		creature:MoveRandom(10) -- Should make idle friendly NPCs roam over unfriendly NPCs to aggro them
	else
		creature:MoveRandom(5) -- Makes them seem a little alive
	end
end

local function OnCreatureDeath(event, creature)
	creature:SetRooted() -- Prevents corpses from sliding around
end

for _, id in ipairs(creatureIDs) do
    RegisterCreatureEvent(id, 5, OnCreatureSpawn)       -- CREATURE_EVENT_ON_SPAWN
    RegisterCreatureEvent(id, 2, OnCreatureLeaveCombat) -- CREATURE_EVENT_ON_LEAVE_COMBAT
    RegisterCreatureEvent(id, 4, OnCreatureDeath)       -- CREATURE_EVENT_ON_DEATH
end
