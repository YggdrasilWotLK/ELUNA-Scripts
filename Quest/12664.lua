--Mostly nick :)'s ELUNA fix for erroneous dialogue gossip range on db scripted NPC

local NPC_ID = 28666
local MENU_ID = 9732
local SPELL_ID = 52194

local function OnGossipHello(event, player, creature)
    player:GossipMenuAddItem(0, "Uhh, can you send me on the tour of Zul'Drak?", 0, 1)
    player:GossipSendMenu(MENU_ID, creature)
    return false
end

local function OnGossipSelect(event, player, creature, sender, intid, code, menu_id)
    if intid == 1 then
        player:CastSpell(player, SPELL_ID, true)
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)
