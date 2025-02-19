local DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/example/link"

-- Function to send a message to the Discord server
local function SendToDiscord(message)
    local payload = '{"content": "' .. message .. '"}'
    HttpRequest("POST", DISCORD_WEBHOOK_URL, payload, "application/json", function(status, body, headers)
        if status == 204 then
            print("Message successfully sent to Discord!")
        else
            print("Failed to send message to Discord. Status: " .. status)
            print("Response body: " .. body)
        end
    end)
end

local function onStartup(event)
    local query = CharDBQuery("SELECT value FROM worldstates WHERE entry = 99999")
    if query and query:GetUInt32(0) then
        CharDBExecute("DELETE FROM worldstates WHERE entry = 99999")
        return
    end
    SendToDiscord("Unscheduled worldserver restart detected! This is most likely a crash or a compose recreate without a gracefully shutdown!")
end

local function onShutdown(event)
    if event == 11 then -- Start shutdown
        CharDBExecute("INSERT INTO worldstates (entry, value, comment) VALUES (99999, 1, 'Worldserver gracefully shut down')")
    elseif event == 12 then -- Cancel shutdown
        CharDBExecute("DELETE FROM worldstates WHERE entry = 99999")
    end
end

RegisterServerEvent(11, onShutdown)
RegisterServerEvent(12, onShutdown)
RegisterServerEvent(14, onStartup)
