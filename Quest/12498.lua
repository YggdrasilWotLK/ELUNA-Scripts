--[[This fixes the missing removal of eat ghoul aura when
    commandeering Wyrmrest Defenders. It is only a concept
    of how ELUNA can be used to compensate for lacking core
    mechanics. Due to its inefficient nature, it is to our
    knowledge not currently in use on any server, but feel
    free to use it if you so please. Made by mostly nick :)
--]]

local EVENT_INTERVAL = 5990  -- 5990 milliseconds (5.99 seconds)
local SPELL_CAST_ID = 50426
local CHECK_AURA_ID = 50343
local REMOVE_AURA_ID = 50437
local CREATURE_ID = 27996
local CHECK_RADIUS = 5

local function CheckPlayersWithAura()
	local players = GetPlayersInWorld()
	local hasAura = false
	for _, player in ipairs(players) do
		if player:HasAura(CHECK_AURA_ID) then
			hasAura = true
			print("[Quest 12498 Fix]: Player has dragon control aura.")
			
			local nearestCreature = player:GetNearestCreature(CHECK_RADIUS, CREATURE_ID)
			if nearestCreature and activeEvent then
				if nearestCreature:HasAura(REMOVE_AURA_ID) then
					nearestCreature:RemoveAura(REMOVE_AURA_ID)
					print("[Quest 12498 Fix]: Removing ghoul aura.")
				end
			end
		end
	end

	if not hasAura then
		print("[Quest 12498 Fix]: No players with aura found. Cancelling event.")
		activeEvent = false
	end
end

local function DelayCheck()
	CreateLuaEvent(CheckPlayersWithAura, EVENT_INTERVAL, 150)
end

local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() == SPELL_CAST_ID then
        print("[Quest 12498 Fix]: Spell 50426 cast. Starting periodic check.")
        CreateLuaEvent(DelayCheck, 22, 1)
    end
end

RegisterPlayerEvent(5, OnSpellCast)
print("[Quest 12498 Fix]: Ruby Wings ghoul fix loaded.")
