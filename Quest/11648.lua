local QUEST_ID = 11648
local SPELL_ID = 45634
local REQUIRED_CASTS = 5

local spellCastCount = {}

local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() == SPELL_ID then
        if player:HasQuest(QUEST_ID) then
            local playerGUID = player:GetGUIDLow()
            spellCastCount[playerGUID] = (spellCastCount[playerGUID] or 0) + 1
            
            if spellCastCount[playerGUID] >= REQUIRED_CASTS then
                player:CompleteQuest(QUEST_ID)
                spellCastCount[playerGUID] = 0
            else
                local remainingCasts = REQUIRED_CASTS - spellCastCount[playerGUID]
            end
        end
    end
end

RegisterPlayerEvent(5, OnSpellCast)
