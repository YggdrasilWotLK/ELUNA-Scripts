-- Mostly nick :)'s fix for erroneous buff handling on bags for quest 11390

local Quest11390Timer = {}

local function CheckPlayerArea(eventId, delay, repeats, player)
	--print("Running periodical check!")
    if player:GetAreaId() ~= 3999 then
        player:RemoveEventById(eventId)
        Quest11390Timer[player:GetGUIDLow()] = nil
		--print("Removing check!")
        return
    end

    if player:HasQuest(11390) then
        local nearestNpc = player:GetNearestCreature(30, 24439) -- Search within 30 yards
        if nearestNpc then
			--print("Bag found!")
            if nearestNpc:HasAura(43789) and not nearestNpc:HasAura(46598) then
                nearestNpc:RemoveAura(43789)
				--print("Bag glitch fixed!")
            end
            
            if nearestNpc:GetZ() > 147 and (not nearestNpc:HasAura(43789) or not nearestNpc:HasAura(46598)) then
				nearestNpc:SetRespawnDelay(30)
                nearestNpc:DespawnOrUnsummon(0) -- Despawn immediately
				--print("Despawning delivered bag!")
            end
        end
    end
end

local function OnEnterArea(event, player, newZone, newArea)
    if newArea == 3999 and not Quest11390Timer[player:GetGUIDLow()] then
		--print("Starting periodical check!")
        local eventId = player:RegisterEvent(CheckPlayerArea, 500, 0) -- 500ms interval, 1800 repeats (15 minutes)
	    Quest11390Timer[player:GetGUIDLow()] = eventId
    end
end

RegisterPlayerEvent(27, OnEnterArea)
