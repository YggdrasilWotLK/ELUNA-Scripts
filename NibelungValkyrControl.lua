-- Makes Nibelung Valkyrs controllable by permanent pet classes (frost mage with glyph, warlock) as they were in retail
-- Written by mostly nick :) for Yggdrasil WoW
local ValkyrAttack = {}
local ValkyrFollow = {}

local function NibelungValkyrFix(event, packet, player)
    if not player then
        return
    end
    
    if ((player:GetClass() == 8 and player:HasAura(70937))
    or player:GetClass() == 9)
    and (player:HasItem(49992) or player:HasItem(50648))
    then
        local petGuid = packet:ReadGUID()  -- Read the Pet GUID
        local count = packet:ReadUByte()   -- Read the count (uint8)
        if count == 2 then
            ValkyrAttack[player:GetName()] = os.time()
        elseif count == 1 then
            ValkyrFollow[player:GetName()] = os.time()
        end
    end
end

local function OnValkyrSpawn(event, player, pet)
    if pet:GetEntry() == 38391
    or pet:GetEntry() == 38392
    then
        name = player:GetName()
        
        pet:RegisterEvent(function(eventId, delay, repeats, pet)
            if pet then
                player = GetPlayerByName(name)
                local attackTime = ValkyrAttack[name] or 0
                local followTime = ValkyrFollow[name] or 0

                if attackTime > followTime and attackTime > os.time() - 1.5 then
                    pet:SetReactState(2)
                    if player:GetSelection() then
                        pet:Attack(player:GetSelection())
                    end
                elseif followTime > os.time() - 1.5 then
                    if pet:GetEntry() == 38391 and pet:IsCasting() then
                        pet:StopSpellCast(71841)
                    elseif pet:IsCasting() then
                        pet:StopSpellCast(71842)
                    end
                    pet:ClearInCombat()
                    pet:SetReactState(0)
                    pet:AttackStop()
                    pet:MoveFollow(player, 3, math.random(0, 6))
                end
            else
                RemoveEventById(eventId)
            end
        end, 1000, 30)
    end
end

RegisterPacketEvent(0x175, 5, NibelungValkyrFix)
RegisterPlayerEvent(43, OnValkyrSpawn)
