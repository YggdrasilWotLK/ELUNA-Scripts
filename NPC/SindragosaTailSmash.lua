local function TailSmashFix(event, sindragosa, spell)
    sindragosa:RegisterEvent(function(e, d, r, sindragosa)
        sindragosa:StopSpellCast()
        sindragosa:CastSpell(sindragosa, 69286, true)
    end, 990 * 2) -- * 2 since AzerothCore has a core-side bug halving the length of timers
end

RegisterSpellEvent(71077, 1, TailSmashFix)

WorldDBExecute("UPDATE spell_dbc SET ExcludeTargetAuraSpell = 70157 WHERE ID = 69286;")
