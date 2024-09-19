-- POS Gargoyle event on the 4 slaves between Ick and the entrance (the ones without a ball and chain)
-- Made for Yggdrasil WoW by mostly nick :)

local MAP_ID = 658
local CHECK_INTERVAL = 7 -- seconds
local AREA = {
    {x = 747, y = 86},
    {x = 818, y = 167},
    {x = 675, y = 245},
    {x = 635, y = 95}
}

local EVENT_TRIGGERED = {}
local PLAYERS_ON_MAP = {}
local CHECK_EVENT_ID = nil

local function IsPointInTriangle(px, py, x1, y1, x2, y2, x3, y3)
    local a = ((y2 - y3) * (px - x3) + (x3 - x2) * (py - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - x3))
    local b = ((y3 - y1) * (px - x3) + (x1 - x3) * (py - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - x3))
    local c = 1 - a - b
    return a >= 0 and a <= 1 and b >= 0 and b <= 1 and c >= 0 and c <= 1
end

local function IsPointInQuadrilateral(px, py, quad)
    return IsPointInTriangle(px, py, quad[1].x, quad[1].y, quad[2].x, quad[2].y, quad[3].x, quad[3].y) or
           IsPointInTriangle(px, py, quad[1].x, quad[1].y, quad[3].x, quad[3].y, quad[4].x, quad[4].y)
end

local function FlyUpAndDespawn(eventId, delay, repeats, creature)
    creature:DespawnOrUnsummon()
end

local function KillNearest(eventId, delay, repeats, creature)
    local nearestCreature1 = creature:GetNearestCreature(25, 36765, 0, 0)
    local nearestCreature2 = creature:GetNearestCreature(25, 36766, 0, 0)
    local nearestCreature3 = creature:GetNearestCreature(25, 36764, 0, 0)
    local nearestCreature4 = creature:GetNearestCreature(25, 36771, 0, 0)
    local nearestCreature5 = creature:GetNearestCreature(25, 36772, 0, 0)
	if nearestCreature1 then
		nearestCreature1:DespawnOrUnsummon()
	end
	if nearestCreature2 then
		nearestCreature2:DespawnOrUnsummon()
	end
	if nearestCreature3 then
		nearestCreature3:DespawnOrUnsummon()
	end
	if nearestCreature4 then
		nearestCreature4:DespawnOrUnsummon()
	end
	if nearestCreature5 then
		nearestCreature5:DespawnOrUnsummon()
	end
    creature:MoveTo(0, creature:GetX(), creature:GetY(), 580)
    creature:RegisterEvent(FlyUpAndDespawn, 9000, 1)
end

local function CheckPlayersAndSpawnNPCs()
    for playerName, _ in pairs(PLAYERS_ON_MAP) do
        player = GetPlayerByName(playerName)
        if player then
            local instance = player:GetInstanceId()
            local x, y, z = player:GetLocation()
            
            if player:GetMapId() ~= 658 then PLAYERS_ON_MAP[playerName] = nil end
            
            if not EVENT_TRIGGERED[instance] and IsPointInQuadrilateral(x, y, AREA) then
                EVENT_TRIGGERED[instance] = true
				
				local npc1 = player:SpawnCreature(36896, 725, 113, 550, 1.33)
				local npc2 = player:SpawnCreature(36896, 742, 158, 574, 3)
				local npc3 = player:SpawnCreature(36896, 718, 168, 575, 4.7)
				local npc4 = player:SpawnCreature(36896, 707, 105, 552, 1.57)
				
				npc1:MoveTo(0, 728, 146, 512)
				npc2:MoveTo(0, npc2:GetX(), npc2:GetY(), 512)
				npc3:MoveTo(0, npc3:GetX(), npc3:GetY(), 512)
				npc4:MoveTo(0, 714, 150, 512)
				
				for _, npc in ipairs({npc1, npc2, npc3, npc4}) do
					npc:SetDisableGravity(true)
					npc:SetReactState(0)
					npc:SetHover(true)
					npc:AddAura(29230, npc)
					npc:RegisterEvent(KillNearest, 9000, 1)
					
					local nearestCreature1 = npc:GetNearestCreature(100, 36765, 0, 0)
					local nearestCreature2 = npc:GetNearestCreature(100, 36766, 0, 0)
					local nearestCreature3 = npc:GetNearestCreature(100, 36764, 0, 0)
					local nearestCreature4 = npc:GetNearestCreature(100, 36771, 0, 0) 
					local nearestCreature5 = npc:GetNearestCreature(100, 36772, 0, 0) 
					if nearestCreature1 then
						nearestCreature1:EmoteState(431)
					end
					if nearestCreature2 then
						nearestCreature2:EmoteState(431)
					end
					if nearestCreature3 then
						nearestCreature3:EmoteState(431)
					end
					if nearestCreature4 then
						nearestCreature4:EmoteState(431)
					end
					if nearestCreature5 then
						nearestCreature5:EmoteState(431)
					end
				end
	
				break
			end
		end
	end
	if next(PLAYERS_ON_MAP) == nil and CHECK_EVENT_ID then
		RemoveEventById(CHECK_EVENT_ID)
		CHECK_EVENT_ID = nil
	end
end

local function OnEnterMap(event, player)
    if player:GetMapId() == MAP_ID then
        PLAYERS_ON_MAP[player:GetName()] = player:GetName()
        
        if not CHECK_EVENT_ID then
            CHECK_EVENT_ID = CreateLuaEvent(CheckPlayersAndSpawnNPCs, CHECK_INTERVAL * 1000, 0)
			print("POS Gargoyle RP event loaded for "..player:GetName().." with event ID "..CHECK_EVENT_ID)
        end
    end
end

RegisterPlayerEvent(28, OnEnterMap)
