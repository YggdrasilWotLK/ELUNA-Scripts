local function ScanAndDespawn(eventId, delay, repeats, player)
    local nearGargoyles = player:GetCreaturesInRange(150, 32769) -- Gargoyle Ambusher npc ID
    for _, gargoyle in ipairs(nearGargoyles) do
		--print("Gargoyle detected! Resetting evasion...")
		gargoyle:MoveChase(player)
    end
end

local function OnAreaTrigger(event, player, newZone, newArea)
    if newArea ~= 4509 then return end -- The bombardment

    local allyPlane = player:GetNearestCreature(25, 31406) -- ally NPC
    local hordePlane = player:GetNearestCreature(25, 31838) -- horde
	--print("Checking for flight vehicle!")
    if allyPlane or nearbyNPC2 then
        player:RegisterEvent(ScanAndDespawn, 5000, 300000 / 5000)
		--print("Flight vehicle found!  Scheduling gargoyle reseter...")
    end
end

RegisterPlayerEvent(27, OnAreaTrigger)
