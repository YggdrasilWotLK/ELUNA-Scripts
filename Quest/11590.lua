local CREATURE_ENTRY = 25316
local CONVERTED_NPC_ID = 25474
local SPELL_ID = 45611
local CONVERSION_DELAY = 3
local RANGE = 5 -- Adjust this value as needed
local CHECK_INTERVAL = 5 -- Check every 5 seconds
local DESPAWN_X = 3611
local DESPAWN_Y = 5963
local DESPAWN_RANGE = 10 -- 30 yards

local EntryIDs = {25316, 25474}
local newScriptName = ""

for _, entry in ipairs(EntryIDs) do
    WorldDBQuery(string.format("UPDATE creature_template SET ScriptName = '%s' WHERE entry = %d", newScriptName, entry))
end

--print("ScriptName updated for entries 25316 and 25474.")

local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() == SPELL_ID then
        --print("Arcane Binding spell cast!")
        
        player:RegisterEvent(function(eventId, delay, repeats, player)
            local x, y, z = player:GetLocation()
            local creature = player:GetNearestCreature(15, CREATURE_ENTRY)
            local auraRemoved = false
            if creature and creature:HasAura(SPELL_ID) then
                --print("Creature converted!")
                local X = creature:GetX()
                local Y = creature:GetY()
                local Z = creature:GetZ()
                local O = creature:GetO()
                local capturedCreature = player:SpawnCreature(25474, X, Y, Z, O, 1, 180000)
                creature:DespawnOrUnsummon()
                capturedCreature:MoveFollow(player)
                capturedCreature:AddAura(45735, capturedCreature)
                player:CastSpell(capturedCreature, 45735, true)
                player:CompleteQuest(11590)
                
                -- Start the periodic check
                capturedCreature:RegisterEvent(function(eventId, delay, repeats, creature)
					if not creature then
						RemoveEventById(eventId())
						--print("Error finding captured creature!")
						return
					end
					--print("Checking for creature location!")
					local creatureX, creatureY, creatureZ = creature:GetLocation()
					
					local creatureDistance = math.sqrt((creatureX - DESPAWN_X)^2 + (creatureY - DESPAWN_Y)^2)
					
					if creatureDistance <= DESPAWN_RANGE then
						--print("Captured creature within range. Despawning creature.")
						creature:DespawnOrUnsummon()
						-- Stop the periodic check
						RemoveEventById(eventId())
					end
				end, CHECK_INTERVAL * 1000, 0)
            end
            player:RemoveEventById(eventId)
        end, CONVERSION_DELAY * 1000, 1)
    end
end

local function OnCreatureSpawn(event, creature)
    if creature:GetEntry() == CONVERTED_NPC_ID then
        creature:SetReactState(0)
    end
end

RegisterCreatureEvent(CONVERTED_NPC_ID, 5, OnCreatureSpawn)
RegisterPlayerEvent(5, OnSpellCast)
