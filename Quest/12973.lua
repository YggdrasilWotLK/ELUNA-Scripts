local eventActive = false

local function StartDialogueSequence(eventId, delay, repeats, brann)
    local currentDelay = 0

    local muradin = brann:GetNearestCreature(100, 29593)
    local magni = brann:GetNearestCreature(100, 30411)
	
    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("By all the gods... it can't be... Muradin?", 0)
        creature:PerformEmote(5)
    end, currentDelay, 1)
    currentDelay = currentDelay + 4000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("What's that? You talkin' to me, lad?", 0)
        creature:NearTeleport(creature:GetX(), creature:GetY(), creature:GetZ(), 5.95)
		
		local brann = creature:GetNearestCreature(100, 30107)
        brann:NearTeleport(brann:GetX(), brann:GetY(), brann:GetZ(), 2.7)
		
    end, currentDelay, 1)
    currentDelay = currentDelay + 3000

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Come on boy, there's no mistak'n it - it's definitely you. Don't ya recognize your younger brother?", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 5500

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("My brother... yes... I do have brothers...", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 4000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitEmote("Muradin clutches his head and reels for a moment as the memories rush back to him.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 3000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("...Brann?", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 3200

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("I can't believe this! You were dead! All accounts said so... what happened, Muradin. How did you get here?", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 6000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("I... I dunno, Brann. I've been 'ere a long time... all I 'ave of me life before this place are flashes and nightmares.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("It's good te see you though, brother. More than words can say.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 6000

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Indeed! Magni will be so happy to see you too! He's gotten nothing but bad news for a long time now, but this changes everything!", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("He's here in Northrend, brother, looking for you. A seer in Wintergarde brought word that you were not dead, and he left Ironforge immediately to come find you.", 0)
	end, currentDelay, 1)
    currentDelay = currentDelay + 100
	
	magni:RegisterEvent(function(eventId, delay, repeats, creature)
		creature:SendUnitYell("Look, Lagnus, I consider you a capable man, but my patience is wearing thin. I know that Muradin is here, can you point me to him or not?", 0)
		creature:SetRooted(false)
	end, currentDelay, 1)
    currentDelay = currentDelay + 4000

	magni:RegisterEvent(function(eventId, delay, repeats, creature)
		creature:SetSpeed(1, 1.6)
		creature:MoveTo(1, 6696.5, -298.78, 989.33)
    end, currentDelay, 1)
    currentDelay = currentDelay + 1000

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Speaking of which...", 0)
		local muradin = creature:GetNearestCreature(100, 29593)
        muradin:NearTeleport(muradin:GetX(), muradin:GetY(), muradin:GetZ(), 2.79)
    end, currentDelay, 1)
    currentDelay = currentDelay + 8000

    magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitYell("Brother! There you are! I can barely believe my eyes... you're alive!", 0)
        creature:NearTeleport(creature:GetX(), creature:GetY(), creature:GetZ(), 3.44)
		
		local muradin = creature:GetNearestCreature(20, 29593)
        muradin:NearTeleport(muradin:GetX(), muradin:GetY(), muradin:GetZ(), 0.18)
		
		local brann = creature:GetNearestCreature(20, 30107)
        brann:NearTeleport(brann:GetX(), brann:GetY(), brann:GetZ(), 2.86)
		
    end, currentDelay, 1)
    currentDelay = currentDelay + 5000*0.61

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Magni! Forgive me, the memories are comin' back slowly, brother.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 6000*0.61

    magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("It's so good to see you again, Muradin. And what's this I heard about you being a King in your own right now? The Bronzebeards were always destined to greatness.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("The frostborn have been very good to me. They're strong people.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 6000

    magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("So it seems! And you haven't lost any muscle yourself. Do you remember anything of what happened, Muradin? Fate as turned ill in your absence.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Not much, Magni. I've had nightmares of a human... tall... light hair... death black armor. His name rests on the tip of me tongue, but...", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 8000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("...Arthas.", 0)
		local magni = creature:GetNearestCreature(100, 30411)
        magni:SendUnitEmote("Magni nods.")
        magni:PerformEmote(273)
    end, currentDelay, 1)
    currentDelay = currentDelay + 3000

    magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("He's not the boy of your memories anymore, Muradin. He's become something else entirely.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000*0.61

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Aye, I know. I watched him turn... I watched him give up all that was right and I didn't lift a hand... I didn't even consider it until it was too late.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("That's in the past, Muradin. Regrets won't change anything.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000*0.61

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("No... no they won't. But I can make this right. I have te. I'm goin' after the boy. I'll make'm answer for everything he's done.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Are you sure Muradin? I just got you back after years of thinking you were dead. I do not want to lose you again.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 9000*0.61

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("I'm sure, Magni. I'll see this through, don't ya worry.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 5000*0.61

    magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("So be it then. I have to return to my people, brothers. Come back to me in one piece.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000*0.61

    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Aye, be safe Muradin. I'd join you, but I'm on top of the most amazing discovery the world has yet seen. I can't abandon it now.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 7000

    muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:SendUnitSay("Go Brann. Bring me back an epic tale when we meet again. Farewell for now, brothers...", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 5000*0.61
	
	muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:PerformEmote(2)
    end, currentDelay, 1)
    currentDelay = currentDelay + 2000*0.61

	muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:MoveHome()
		local magni = creature:GetNearestCreature(10, 30411)
        magni:SendUnitSay("...farewell brother.", 0)
    end, currentDelay, 1)
    currentDelay = currentDelay + 1000*0.61
	
    brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:MoveHome()
    end, currentDelay, 1)
    currentDelay = currentDelay + 100*0.61
	
    magni:RegisterEvent(function(eventId, delay, repeats, creature)
		creature:SetSpeed(1, 0.4)
        creature:MoveTo(1,6733,-285,990)
    end, currentDelay, 1)
    currentDelay = currentDelay + 15000*0.61

	muradin:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:DespawnOrUnsummon()
    end, currentDelay, 1)
	
	brann:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:DespawnOrUnsummon()
    end, currentDelay, 1)
	
	magni:RegisterEvent(function(eventId, delay, repeats, creature)
        creature:DespawnOrUnsummon()
		eventActive = false
    end, currentDelay, 1)
end


local function SpawnAndMoveBrann(eventId, delay, repeats, player)
	player:SetPhaseMask(1)
    local brann = player:SpawnCreature(30107, 6731, -296, 993.82, 0, 3, 200000)
    brann:SetSpeed(1, 0.4)
    brann:MoveTo(1, 6697, -302.8, 989.4)
	
    local muradin = player:SpawnCreature(29593, 6652, -310, 989.38, 0, 3, 200000)
    muradin:SetSpeed(1, 0.4)
    muradin:MoveTo(1, 6691, -300.9, 989.38)
	
    local magni = player:SpawnCreature(30411, 6710.89, -278.15, 956.42, 0, 3, 200000)
	magni:SetRooted(true)
	
    brann:RegisterEvent(StartDialogueSequence, 10000, 1)
	
	brann:SetPhaseMask(4)
	muradin:SetPhaseMask(4)
	magni:SetPhaseMask(4)
	player:SetPhaseMask(4)
end

-- Event when a player enters a new zone/area
local function OnPlayerUpdateZone(event, player, newZone, newArea)
    if newArea == 4428 and not eventActive then -- Check if the player is in area 4428
        print("Player is in area 4428")
        if player:HasQuest(12973) then -- Check if the player has quest ID 12973
            print("Player has quest ID 12973")
            local Brann = player:GetNearestCreature(20, 30107) -- Get Brann within 20 yards
            local FlyingMachine = player:GetNearestCreature(20, 30134) -- Get FlyingMachine within 20 yards
            if Brann and FlyingMachine then -- If both Brann and FlyingMachine are present
                print("Both Brann and FlyingMachine are present")
                -- Schedule the spawn of Brann after 9 seconds
                player:RegisterEvent(SpawnAndMoveBrann, 6600, 1)
                print("Scheduled Brann to spawn in 6 seconds")
				eventActive = true
            end
        end
    end
end

RegisterPlayerEvent(27, OnPlayerUpdateZone) -- Register the function to be triggered on zone/area update
