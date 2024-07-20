-- Rescript of Zelfrax in Dustwallow to avoid double spawns from faulty CPP script. Requires that the original Zelfrax NPC ID be cloned to 238640 (from 23864) and the original must be set to invisible and passive. 
-- made by mostly nick :)
local SPELL_ID = 42521
local ITEM_ID = 33113
local NPC_ID = 238640
local QUEST_ID = 11183
local SPAWN_X = -2984.31
local SPAWN_Y = -3853.15
local SPAWN_Z = 45.63
local SPAWN_O = 5.4137
local DEST_X = -2967.5769
local DEST_Y = -3871.569
local DEST_Z = 34.27
local AURA_ID = 29230  -- Aura ID to add and remove

local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() == SPELL_ID then
        print("Spell cast with ID " .. SPELL_ID)
        if player:HasItem(ITEM_ID) then
            print("Player has item with ID " .. ITEM_ID)
            player:RegisterEvent(function(eventId, delay, repeats, p)
                print("Spawning Zelfrax after 14 seconds...")
                local zelfrax = p:SpawnCreature(NPC_ID, SPAWN_X, SPAWN_Y, SPAWN_Z, SPAWN_O, 3, 300000)
                if zelfrax then
                    zelfrax:SetDisableGravity(true)
                    zelfrax:SetHover(false)
                    zelfrax:AddAura(AURA_ID, zelfrax)  -- Add the aura when spawning

                    print("Zelfrax spawned with ID " .. NPC_ID)
                    zelfrax:RegisterEvent(function(eventId, delay, repeats, creature)
                        print("Zelfrax is yelling the first message.")
                        creature:SendUnitYell("This land was mine long before you wretched kind set foot here.", 0)
                    end, 0, 1)
                    zelfrax:RegisterEvent(function(eventId, delay, repeats, creature)
                        print("Zelfrax is yelling the second message.")
                        creature:SendUnitYell("All who venture here belong to me, including you!", 0)
                    end, 5000, 1)
                    zelfrax:RegisterEvent(function(eventId, delay, repeats, creature)
                        print("Zelfrax is moving to the fixed location.")
                        creature:MoveStop()
                        creature:MoveIdle()
                        creature:SetDisableGravity(true)
                        creature:SetHover(false)
                        creature:MoveTo(1, DEST_X, DEST_Y, DEST_Z)
                        print("Zelfrax is set to attackable.")
                    end, 6000, 1)
					
                    zelfrax:RegisterEvent(function(eventId, delay, repeats, creature)
                        print("Removing aura " .. AURA_ID .. " from Zelfrax.")
                        creature:RemoveAura(AURA_ID)
                    end, 6150, 1)

                    -- Register continuous update of chase target
                    zelfrax:RegisterEvent(function(eventId, delay, repeats, creature)
                        local aggroTarget = creature:GetVictim()
                        if aggroTarget and aggroTarget:IsPlayer() then
                            creature:MoveChase(aggroTarget)
                        end
                    end, 6150, 0)  -- Repeat indefinitely to update chase target continuously

                else
                    print("Failed to spawn Zelfrax.")
                end
            end, 14000, 1)
        else
            print("Player does not have item with ID " .. ITEM_ID)
        end
    end
end

local function OnCreatureDeath(event, creature, killer)
    if creature:GetEntry() == NPC_ID then
        print("Zelfrax with ID " .. NPC_ID .. " was killed.")
        local groupMembers = killer:GetGroup()
        if groupMembers then
            for _, member in ipairs(groupMembers:GetMembers()) do
                if member:IsPlayer() then
                    print("Group member " .. member:GetName() .. " is eligible for quest credit.")
                    member:CompleteQuest(QUEST_ID)
                end
            end
        else
            -- If killer is not in a group, just give credit to the killer
            if killer:IsPlayer() then
                print("Killer is a player. Completing quest with ID " .. QUEST_ID)
                killer:CompleteQuest(QUEST_ID)
            else
                print("Killer is not a player.")
            end
        end
    end
end

RegisterPlayerEvent(5, OnSpellCast)
RegisterCreatureEvent(NPC_ID, 4, OnCreatureDeath)
print("[NPC]: Zelfrax Script loaded!")
