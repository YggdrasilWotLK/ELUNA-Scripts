local function AcherusEyeFix(event, packet, player)
    if not player then
        return
    end
    
    local guid = packet:ReadGUID()  -- Read the GUID first
    local castCount = packet:ReadUByte()  -- Read the cast count (uint8)
    local spellId = packet:ReadULong()  -- Read the spell ID (uint32)
    local castFlags = packet:ReadUByte()  -- Read the cast flags (uint8)
    
    if spellId == 52694 then
        player:RemoveAura(51852)
    end
end

RegisterPacketEvent(0x1F0, 5, AcherusEyeFix)
