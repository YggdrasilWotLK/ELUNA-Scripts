-- Prevents 3rd+ passenger getting stuck in Ulduar siege engines
-- Made by Mostly nick :) for Yggdrasil WoW

local ulduarVehiclePlayers = {}

local function OnEnterVehicle(event, packet, player)
    print("Enter Vehicle event triggered")
    
    if not player then
        return
    end
    print(string.format("Player object found: %s", player:GetName()))
    
    local selection = player:GetSelection()
    if not selection then
        return
    end
    print(string.format("Selection found with GUID: %d", selection:GetGUIDLow()))
    
    -- Check if the selected vehicle is Salvaged Demolisher
    local entryId = selection:GetEntry()
    print(string.format("Checking entry ID: %d", entryId))
    
    if entryId == 33060 then
        print("Salvaged Demolisher (33060) confirmed")
        local vehicleGUID = selection:GetGUIDLow()
        local instanceId = player:GetInstanceId()
        local vehicleKey = string.format("%d:%d", instanceId, vehicleGUID)
        print(string.format("Vehicle GUID: %d, Instance ID: %d", vehicleGUID, instanceId))
        
        -- Initialize table for this vehicle if it doesn't exist
        if not ulduarVehiclePlayers[vehicleKey] then
            print(string.format("Creating new entry for vehicle %s", vehicleKey))
            ulduarVehiclePlayers[vehicleKey] = {}
        else
            print(string.format("Found existing entry for vehicle %s with %d players", 
                vehicleKey, #ulduarVehiclePlayers[vehicleKey]))
        end
        
        -- Check if vehicle already has 2 or more players
        if #ulduarVehiclePlayers[vehicleKey] >= 2 then
            print(string.format("Vehicle %s is full! Preventing entry", vehicleKey))
            return false
        end
        
        -- Add player to vehicle's player list
        table.insert(ulduarVehiclePlayers[vehicleKey], player:GetName())
        print(string.format("Added player %s to vehicle %s", player:GetName(), vehicleKey))
        print(string.format("Vehicle %s now has %d players", 
            vehicleKey, #ulduarVehiclePlayers[vehicleKey]))
        return true
    end
end

local function OnLeaveVehicle(event, player, playerPacket)
    print(string.format("Leave Vehicle event triggered. Event type: %d", event))
    
    local playerName
    local instanceId
    
    -- Determine which player object to use based on event type
    if event == 4 or event == 8 then
        playerName = player:GetName()
        instanceId = player:GetInstanceId()
        print(string.format("Player logout/disconnect event for: %s in instance %d", playerName, instanceId))
    else
        playerName = playerPacket:GetName()
        instanceId = playerPacket:GetInstanceId()
        print(string.format("Vehicle leave packet event for: %s in instance %d", playerName, instanceId))
    end
    
    local found = false
    
    -- Search through all vehicles and remove player
    for vehicleKey, players in pairs(ulduarVehiclePlayers) do
        local keyInstanceId = tonumber(vehicleKey:match("(%d+):"))
        
        -- Only process vehicles in the same instance
        if keyInstanceId == instanceId then
            print("Checking vehicle ".. vehicleKey..". The vehicle carries "..#players.." players.")
            
            for i = #players, 1, -1 do
                if players[i] == playerName then
                    print(string.format("Found player %s in vehicle %s at position %d", 
                        playerName, vehicleKey, i))
                    table.remove(players, i)
                    found = true
                    print("Removed player "..playerName.." from vehicle "..vehicleKey..". Players left: "..#players)
                    
                    -- Clean up empty vehicle entries
                    if #players == 0 then
                        ulduarVehiclePlayers[vehicleKey] = nil
                    end
                    break
                end
            end
            if found then
                break
            end
        end
    end
end

RegisterPacketEvent(0x3F8, 5, OnEnterVehicle)
RegisterPacketEvent(0x46D, 5, OnLeaveVehicle)
RegisterPlayerEvent(4, OnLeaveVehicle)
RegisterPlayerEvent(8, OnLeaveVehicle)
