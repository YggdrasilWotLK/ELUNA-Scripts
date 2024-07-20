-- Simple LUA imitation of the TrinityCore ".go offset" command, for Azerothcore
-- Made by mostly nick :)

-- Variables the command checks for
local commandPrefix = "go"
local commandName = "offset"

-- Helper function to parse input and convert to numbers
local function ParseCommand(message)
    local _, _, x, y, z = string.find(message, commandPrefix .. " " .. commandName .. " ([%d%-%.]+) ([%d%-%.]+) ([%d%-%.]+)")
    return tonumber(x), tonumber(y), tonumber(z)
end

-- Function to handle the command
local function TeleportOffset(event, player, message, type, language)
    -- Check if the message starts with the command
    if (message:lower():match("^" .. commandPrefix .. " " .. commandName)) then
        -- Only allow GMs to use this command
        if (player:IsGM()) then
            -- Parse the message to get the X, Y, Z offsets
            local x, y, z = ParseCommand(message)
            
            if x and y and z then
                -- Get the player's current position
                local px, py, pz, po = player:GetLocation()
                
                -- Calculate the new position
                local newX = px + x
                local newY = py + y
                local newZ = pz + z

                -- Teleport the player to the new position
                player:Teleport(player:GetMapId(), newX, newY, newZ, po)

                -- Notify the player
                player:SendBroadcastMessage("Teleported to offset location: (" .. newX .. ", " .. newY .. ", " .. newZ .. ")")
            else
                player:SendBroadcastMessage("Invalid command format. Use: " .. commandPrefix .. " " .. commandName .. " X Y Z")
            end

            -- Block the command from being sent to the chat
            return false
        else
            player:SendBroadcastMessage("You do not have permission to use this command.")
            return false
        end
    end
end

-- Register the command handler
RegisterPlayerEvent(42, TeleportOffset)
print("[Command]: .go offset command loaded!")
