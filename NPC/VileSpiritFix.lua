-- NPD IDs
local NPC_ID = 37799 -- Raging Spirit NPC ID
local SPELL_ID = 70503 -- Explosion Spell ID

-- Timers
local CLIMB_DURATION = 2000 -- Wandering starts X ms after spawn
local CHASE_START = 15000 -- Chase starts X ms after completed climb
local CHASE_CHECK = 1000 -- Frequency in MS to check chase and explosion
local EXPLOSION_CHECK = 200 -- Frequency in MS to check chase and explosion

-- Coords
local Z_COORD = 853.4
local Z_VARIANCE = 2
local CHASE_RADIUS = 200
local WANDER_RADIUS = 5
local EXPLOSION_RADIUS = 1.5

-- Table to store event IDs for each creature
local creatureEvents = {}

function NPC_OnSpawn(event, creature)
    creature:SetDisableGravity(true) 
    creature:SetHover(false)
    creature:SetImmuneTo(0,true)
    creature:SetSpeed(0,0.9)
    creature:SetSpeed(1,1.15)
    creature:SetReactState(0)
    creature:MoveTo(1, creature:GetX(), creature:GetY(), Z_COORD + math.random(-Z_VARIANCE, Z_VARIANCE))
    print("[NPC]: Vile Spirit Fix - Spawned NPC and called move up!")
    
    creature:RegisterEvent(NPC_Wander, CLIMB_DURATION, 1)
end

function NPC_Wander(event, delay, pCall, creature)
    print("[NPC]: Vile Spirit Fix - Wander initiated!")
    
    creature:MoveRandom(WANDER_RADIUS)
    
    creature:RegisterEvent(NPC_StartChasing, CHASE_START, 1) -- Register an event to start chasing after the wander duration
end

function NPC_StartChasing(event, delay, pCall, creature)
    creature:SetReactState(2)
    local guid = creature:GetGUID()
    creatureEvents[guid] = creatureEvents[guid] or {}
    creatureEvents[guid].proximityEventId = creature:RegisterEvent(NPC_CheckProximity, CHASE_CHECK, 0)
    creature:RegisterEvent(NPC_CheckExplode, EXPLOSION_CHECK, 0)
end

function NPC_CheckExplode(event, delay, pCall, creature)
    print("[NPC]: Vile Spirit Fix - Explosion check initiated!")
    
    local nearestPlayerExplosion = creature:GetNearestPlayer(EXPLOSION_RADIUS)
    
    if nearestPlayerExplosion then
        print("[NPC]: Vile Spirit Fix - Spirit in explosion range!")
        creature:CastSpell(nearestPlayerExplosion, SPELL_ID, true)
        creature:DespawnOrUnsummon()
        creature:RemoveEvents()
    end
end

function NPC_CheckProximity(event, delay, pCall, creature)
    local nearestPlayer = creature:GetNearestPlayer(CHASE_RADIUS)
    
    local moveX, moveY, moveZ
    
    if nearestPlayer then
        if creature:GetDistance(nearestPlayer) > 10 then
            moveX = nearestPlayer:GetX()
            moveY = nearestPlayer:GetY()
            moveZ = nearestPlayer:GetZ()
            creature:MoveTo(2, moveX, moveY, moveZ)
            print("[NPC]: Vile Spirit Fix - Chasing target!")
        end
    end
end

function NPC_OnLeaveCombat(event, creature)
    creature:DespawnOrUnsummon()
    creature:RemoveEvents()
    local guid = creature:GetGUID()
    creatureEvents[guid] = nil -- Remove the creature's entry from the table
end

function NPC_OnSpellHit(event, creature, caster, spellid)
    if spellid == 49576 or spellid == 1161 or spellid == 31789 or spellid == 5209 or spellid == 56222 or spellid == 6795 or spellid == 355 or spellid == 62124 then
        creature:SetReactState(1)
        local guid = creature:GetGUID()
        if creatureEvents[guid] and creatureEvents[guid].proximityEventId then
            creature:RemoveEventById(creatureEvents[guid].proximityEventId)
            creatureEvents[guid].proximityEventId = nil
        end
    end
end

RegisterCreatureEvent(NPC_ID, 2, NPC_OnLeaveCombat)
RegisterCreatureEvent(NPC_ID, 5, NPC_OnSpawn)
RegisterCreatureEvent(NPC_ID, 14, NPC_OnSpellHit)