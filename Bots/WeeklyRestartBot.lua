local function GetTimeUntilNextRestart()
    local currentTime = os.time()
    local currentDate = os.date("*t", currentTime)
    local daysUntilWednesday = (3 - currentDate.wday + 7) % 7
    
    local nextWednesday = os.time({
        year = currentDate.year, 
        month = currentDate.month, 
        day = currentDate.day + daysUntilWednesday, 
        hour = 10, 
        min = 0, 
        sec = 0
    })
    
    -- If it's past 10 AM on Wednesday, move to next Wednesday
    if nextWednesday <= currentTime then
        nextWednesday = nextWednesday + 7 * 24 * 60 * 60 -- Add 7 days
    end
    
    -- Return the time difference until the next restart
    return nextWednesday - currentTime
end

local function ScheduledRestart()
    RunCommand("server restart 900 Periodical restart. Will be back shortly.")
end

local timeUntilRestart = GetTimeUntilNextRestart()
eventid = CreateLuaEvent(ScheduledRestart, timeUntilRestart * 1000, 1)
print("[Bot]: Restart bot loaded with event ID "..eventid..". Time until next restart: " .. math.floor(timeUntilRestart / 3600) .. " hours, " .. math.floor((timeUntilRestart % 3600) / 60) .. " minutes.")
