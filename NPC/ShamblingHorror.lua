local NPC_ID = 37698
local SPELL_SHOCKWAVE = 72149
local SPELL_ENRAGE = 72143
local SPELL_FRENZY = 28747
local HORRORS = {}

local function RemoveImmunity(eventid, delay, repeats, creature)
    creature:RemoveAura(52165)
    creature:RemoveAura(29230)
	creature:ClearUnitState(1)
	print("[NPC]: Shambling Horror - Animation fix, immunity aura removed!")
end

local function OnNPCSpawn(event, creature)
	creature:AddUnitState(1)
	creature:AddAura(52165, creature)
	creature:AddAura(29230, creature)
	print("[NPC]: Shambling Horror - Animation fix, immunity aura added!")
    creature:PerformEmote(449) -- Crawl animation
	creature:RegisterEvent(RemoveImmunity, 4200, 1)
end

local function OnReset(event, creature)
    creature:SetData("shockwave_timer", math.random(20000, 25000))
    creature:SetData("enrage_timer", math.random(11000, 14000))
    creature:SetData("frenzied", 0)
end

local function OnDamageTaken(event, creature, attacker, damage)
    if creature:GetData("frenzied") == 0 and creature:GetMap():IsHeroic() and creature:GetHealthPct() < 20 then
        creature:SetData("frenzied", 1)
        creature:CastSpell(creature, SPELL_FRENZY, true)
    end
end

local function OnUpdateAI(event, creature, diff)
    if not creature:IsInCombat() then
        return
    end

    if not creature:GetVictim() then
        creature:SelectVictim()
        return
    end

    if creature:IsCasting() then
        return
    end

    local shockwave_timer = creature:GetData("shockwave_timer")
    if not shockwave_timer or shockwave_timer <= diff then
        creature:CastSpell(creature:GetVictim(), SPELL_SHOCKWAVE, false)
        creature:SetData("shockwave_timer", math.random(20000, 25000))
    else
        creature:SetData("shockwave_timer", shockwave_timer - diff)
    end

    -- Handle Enrage
    local enrage_timer = creature:GetData("enrage_timer")
    if not enrage_timer or enrage_timer <= diff then
        creature:CastSpell(creature, SPELL_ENRAGE, false)
        creature:SetData("enrage_timer", math.random(11000, 14000))
    else
        creature:SetData("enrage_timer", enrage_timer - diff)
    end
end

-- Register the events for the NPC
RegisterCreatureEvent(NPC_ID, 5, OnNPCSpawn)
RegisterCreatureEvent(NPC_ID, 7, OnUpdateAI)
RegisterCreatureEvent(NPC_ID, 9, OnDamageTaken)
RegisterCreatureEvent(NPC_ID, 23, OnReset)