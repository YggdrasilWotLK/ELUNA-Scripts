
-- This ELUNA module sets the faction of all players in an instance to the same as the first player to enter it.
-- Written by mostly nick :) for Yggdrasil WoW

local cachedFaction = {}

local function OnPlayerMapChange(event, player)
    local instanceId = player:GetInstanceId()
    local mapId = player:GetMapId()
	
	if mapId == 631 or mapId == 658 -- ICC and the Frozen Halls maps
	or mapId == 632 or mapId == 668 -- The Frozen Halls maps
    
	
	then
		if instanceId and instanceId > 0 then
            player:RegisterEvent(function(eventId, delay, repeats, player)
                if not cachedFaction[instanceId] then    
                    if (mapId == 631 and (player:GetNearestCreature(1000, 39372) or player:GetNearestCreature(20000, 37187)))
                    or (mapId == 632 and player:GetNearestCreature(1000, 37596))
                    or (mapId == 658 and player:GetNearestCreature(1000, 36990))
                    or (mapId == 668 and player:GetNearestCreature(1000, 37223))
                    or (mapId == 631 and player:HasAura(73822))
                    then -- horde instance. 39372 hellscream at entrance. maps 632, 658, and 668 are Sylvanas Windrunner
                        cachedFaction[instanceId] = 1801
                        print("ICC, instance ID "..instanceId..": Horde instance detected! Setting player faction to horde.")
                        if (player:GetRace() == 1 or player:GetRace() == 3
                        or player:GetRace() == 4 or player:GetRace() == 7
                        or player:GetRace() == 11) then
                            player:SetFaction(1801) -- horde faction adjustment
                        end
                    elseif (mapId == 631 and (player:GetNearestCreature(1000, 39372) or player:GetNearestCreature(20000, 37200)))
                    or (mapId == 632 and player:GetNearestCreature(1000, 37597))
                    or (mapId == 658 and player:GetNearestCreature(1000, 36993))
                    or (mapId == 668 and player:GetNearestCreature(1000, 37221))
                    or (mapId == 631 and player:HasAura(73828))
                    then -- ally instance. 39371 is wrynn at entrance. maps 632, 658, and 668 are Lady Jaina Proudmoore
                        cachedFaction[instanceId] = 1802
                        print("ICC, instance ID "..instanceId..": Ally instance detected! Setting player faction to alliance.")
                        if (player:GetRace() == 2 or player:GetRace() == 5
                        or player:GetRace() == 6 or player:GetRace() == 8
                        or player:GetRace() == 10) then
                            player:SetFaction(1802) -- ally  faction adjustment
                        end
                    end
                else
                    print("Frozen Halls Faction Adjustment - player "..player:GetName().." just entered map ID "..mapId.."! Faction cached for instance ID "..instanceId..": "..cachedFaction[instanceId])
                    for _, playersInInstances in pairs(GetPlayersInWorld()) do
                        if playersInInstances:GetInstanceId() == instanceId then
                            print("ICC, instance ID "..instanceId..": Cached faction found, setting playersInInstances faction to alliance.")
                            print("playersInInstances "..playersInInstances:GetName().." race: "..playersInInstances:GetRace())
                            if cachedFaction[instanceId] == 1801
                            and (playersInInstances:GetRace() == 1 or playersInInstances:GetRace() == 3
                            or playersInInstances:GetRace() == 4 or playersInInstances:GetRace() == 7
                            or playersInInstances:GetRace() == 11)
                            then -- Horde faction adjustment
                                playersInInstances:SetFaction(35)
                                playersInInstances:SetFaction(1801)
                            elseif cachedFaction[instanceId] == 1802
                            and (playersInInstances:GetRace() == 2 or playersInInstances:GetRace() == 5
                            or playersInInstances:GetRace() == 6 or playersInInstances:GetRace() == 8
                            or playersInInstances:GetRace() == 10)
                            then
                                playersInInstances:SetFaction(35)
                                playersInInstances:SetFaction(1802)
                            end
                        end
                    end
                end
            end, 500, 1)
        end
    else
        if player and not (
        (player:GetRace() == 1 and player:GetFaction() == 1) or -- Human
        (player:GetRace() == 2 and player:GetFaction() == 2) or -- Orc
        (player:GetRace() == 3 and player:GetFaction() == 3) or -- Dwarf
        (player:GetRace() == 4 and player:GetFaction() == 4) or -- Night Elf
        (player:GetRace() == 5 and player:GetFaction() == 5) or -- Undead
        (player:GetRace() == 6 and player:GetFaction() == 6) or -- Tauren
        (player:GetRace() == 7 and player:GetFaction() == 115) or -- Gnome
        (player:GetRace() == 8 and player:GetFaction() == 116) or -- Troll
        (player:GetRace() == 10 and player:GetFaction() == 1610) or -- Blood elf
        (player:GetRace() == 11 and player:GetFaction() == 1629)) -- Draenei
        then
            print("Faction discrepancy detected, resetting player "..player:GetName().."! Current faction: "..player:GetFaction())
            player:SetFactionForRace(player:GetRace())
            print("Faction discrepancy detected, resetting player "..player:GetName().."! New faction: "..player:GetFaction())
        end
    end
end

function CacheCurrentInstances()
    local validMaps = {631, 632, 658, 668}
    local allianceFactions = {1, 3, 4, 115, 1629, 1802}
    
    local function isValidMap(mapId)
        for _, validMap in pairs(validMaps) do
            if mapId == validMap then
                return true
            end
        end
        return false
    end
    
    local function isAllianceFaction(factionId)
        for _, allianceFaction in pairs(allianceFactions) do
            if factionId == allianceFaction then
                return true
            end
        end
        return false
    end
    
    for _, player in pairs(GetPlayersInWorld()) do
        local instanceId = player:GetInstanceId()
        local mapId = player:GetMapId()
        
        if instanceId > 0 and isValidMap(mapId) then
            if not cachedFaction[instanceId] then
                for _, instancePlayer in pairs(GetPlayersInWorld()) do
                    if instancePlayer:GetInstanceId() == instanceId then
                        local faction = instancePlayer:GetFaction()
                        
                        if isAllianceFaction(faction) then
                            cachedFaction[instanceId] = 1802 -- Alliance
                            print("Instance ID "..instanceId..": Cached as Alliance (1802)")
                            break
                        else
                            cachedFaction[instanceId] = 1801 -- Horde
                            print("Instance ID "..instanceId..": Cached as Horde (1801)")
                            break
                        end
                    end
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------
-- Faction adjustment event registrations
------------------------------------------------------------------------------------------------

CacheCurrentInstances()
RegisterPlayerEvent(28, OnPlayerMapChange)

------------------------------------------------------------------------------------------------
-- End faction adjustment event registrations
------------------------------------------------------------------------------------------------
