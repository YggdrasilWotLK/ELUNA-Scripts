--Makes an NPC that should appear dead get "Feign Death Permanent" applied on server start/reload eluna. 

local NPC_ID = 31281
local AURA_ID = 58951
local AREA_CODE3 = 210
local APPLIED = 0

local function SetInitialState()
	local APPLIED = 0
end

-- Function to apply the aura to a specific NPC
local function ApplyAura(npc)
    if npc and not npc:HasAura(AURA_ID) then
        npc:AddAura(AURA_ID, npc)
		APPLIED = 1
        print(string.format("[NPC FIX 31281]: Applied aura %d to NPC %d", AURA_ID, npc:GetEntry()))
    end
end

-- Event handler for when a player enters a new area
local function OnPlayerEnterArea(event, player, newAreaId, newZoneId)
	if APPLIED == 1 then end
    if APPLIED == 0 and newAreaId == AREA_CODE3 then	
		--print("Area detected!")
        local creature = player:GetNearestCreature(1000,NPC_ID)  -- Adjust range as needed
        if creature then
			ApplyAura(creature)
        end
    end
end

-- Register the event to trigger when a player enters a new area
RegisterPlayerEvent(27, OnPlayerEnterArea)
RegisterServerEvent(33, SetInitialState)

print("[NPC]: Creature no. 31281 fix (Dead Alliance Soldier permanent feign death) loaded!")
