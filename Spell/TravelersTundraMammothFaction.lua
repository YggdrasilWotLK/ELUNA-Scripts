-- Corrects the faction of Traveler's Tundra Mammoth if players have the wrong one from e.g., faction changes

local function OnLogin(event, player)
    if not player:IsAlliance() and player:HasSpell(61425) then
        player:RemoveSpell(61425)
        player:LearnSpell(61447)
    end
    if player:IsAlliance() and player:HasSpell(61447) then
        player:RemoveSpell(61447)
        player:LearnSpell(61425)
    end   
end

RegisterPlayerEvent(3, OnLogin)
