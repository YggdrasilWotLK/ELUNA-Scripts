-- Applies missing wisp form. Breaks on relog during quest but who would relog during this quest anyway?
-- Made by mostly nick :)

local SPELL_ID = 47190
local DISPLAY_ID = 24465
local MORPH_DELAY_MS = 100
local DEMORPH_DELAY_MS = 3*60*1000

local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() == SPELL_ID then
        local playerGUID = player:GetGUID()
        player:RegisterEvent(function()
            local playerObject = GetPlayerByGUID(playerGUID)
            if playerObject then
                playerObject:SetDisplayId(DISPLAY_ID)
            end
        end, MORPH_DELAY_MS)
        player:RegisterEvent(function()
            local playerObject = GetPlayerByGUID(playerGUID)
            if playerObject then
                playerObject:DeMorph()
            end
        end, DEMORPH_DELAY_MS)
    end
end

RegisterPlayerEvent(5, OnSpellCast)
