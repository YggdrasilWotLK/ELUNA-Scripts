-- Current AzerothCore doesn't trigger debuff removal on being underwater. This script checks players with debuff every specified interval to spawn blood pool in water.
-- Made by mostly nick :)

local BOREAN_ANIMAL_BLOOD = 46221
local SPELL_TO_CAST = 63471
local CHECK_DURATION = 180
local CHECK_FREQUENCY = 2000 -- Check once per 2 seconds

local playersWithBloodEvent = {}

local function CheckPlayerInWater(eventId, delay, repeats, playerGuid)
    local player = GetPlayerByGUID(playerGuid)
	--print("Event to check whether players are in water initiated.")
    if player then
        if not player:HasAura(BOREAN_ANIMAL_BLOOD) then
            player:RemoveEventById(eventId)
            playersWithBloodEvent[playerGuid] = nil
            --print("Player no longer has the aura, event removed!")
            return
        end

        if player:IsInWater() then
            --print("Player is in water!")
            player:CastSpell(player, SPELL_TO_CAST, true)
            player:RemoveAura(BOREAN_ANIMAL_BLOOD)
            player:RemoveEventById(eventId)
            playersWithBloodEvent[playerGuid] = nil
            print("[Spell]: Borean Tundra animal blood - Water pool spawned!")
        end
    else
        -- If the player object can't be found, remove the event
        --print("Player not found, event removed!")
    end
end

local function OnKillCreature(event, killer, killed)
    if killed:GetCreatureType() == 1 then
    --print("Beast killed!")
        local playerGuid = killer:GetGUIDLow()
        if not playersWithBloodEvent[playerGuid] then
            local eventId = killer:RegisterEvent(function(eventId, delay, repeats)
                CheckPlayerInWater(eventId, delay, repeats, playerGuid)
            end, 1000, CHECK_DURATION)
            playersWithBloodEvent[playerGuid] = eventId
            --print("Animal killed in Borean Tundra registered!")
        end
    end
end

local function OnZoneUpdate(event, player, newZone, newArea)
    local mapId = player:GetMapId()
    if newArea and (mapId == 571 or mapId == 1 or mapId == 0 or mapId == 530) then
        local playerGuid = player:GetGUIDLow()
        --print("Player entered new area in Northrend!")
		if playersWithBloodEvent[playerGuid] then 
			playersWithBloodEvent[playerGuid] = nil
		end
        if player:HasAura(BOREAN_ANIMAL_BLOOD) then
            local eventId = player:RegisterEvent(function(eventId, delay, repeats)
                CheckPlayerInWater(eventId, delay, repeats, playerGuid)
            end, CHECK_FREQUENCY, CHECK_DURATION)
            playersWithBloodEvent[playerGuid] = eventId
        end
    end
end

RegisterPlayerEvent(7, OnKillCreature)
RegisterPlayerEvent(27, OnZoneUpdate)
print("[Spell]: Borean Tundra animal blood water spawner loaded!")
