local YGGDRAS = 30014
local STINKBEARD = 30017
local ELEMENTAL1 = 30024
local ELEMENTAL2 = 30026
local ELEMENTAL3 = 30019
local ELEMENTAL4 = 30025
local ORINOKO = 30020
local KORRAK = 30023
local ANNOUNCER_ID = 30007
local SEARCH_RANGE = 200

local function OnPlayerKillCreature(event, killer, killed)
    if killed:GetEntry() == YGGDRAS or killed:GetEntry() == STINKBEARD
	or killed:GetEntry() == ELEMENTAL or killed:GetEntry() == ORINOKO
	or killed:GetEntry() == KORRAK then 
		
        local killer = killer:GetName()
		
        local announcer = killed:GetNearestCreature(SEARCH_RANGE, ANNOUNCER_ID)
        
        if announcer and killed:GetEntry() == YGGDRAS then
            announcer:SendUnitYell(""..killer.. " has defeated Yg... Yggg-really big worm!", 0)
        end
        if announcer and (
		killed:GetEntry() == ELEMENTAL1 or
		killed:GetEntry() == ELEMENTAL2 or
		killed:GetEntry() == ELEMENTAL3 or
		killed:GetEntry() == ELEMENTAL4 or
		killed:GetEntry() == ORINOKO or
		killed:GetEntry() == KORRAK) then
            announcer:SendUnitYell(""..killer.. " is victorious once more!", 0)
        end
        if announcer and killed:GetEntry() == STINKBEARD then
            announcer:SendUnitYell("And with AUTHORITY, "..killer.." dominates the magnataur lord! Stinkbeard's clan is gonna miss him back home in the Dragonblight!", 0)
        end
    end
end

RegisterPlayerEvent(7, OnPlayerKillCreature)
