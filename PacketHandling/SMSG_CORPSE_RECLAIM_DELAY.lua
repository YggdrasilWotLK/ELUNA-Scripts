-- Fixes AzerothCore's issue with players dying while under immunity effects getting stuck as alive but flagged as dead

local function killPlayer(e, d, r, player)
	if player:GetHealth() == 0 then return end -- Don't try to kill if HP is 0 (then player is actually dead, as opposed to the IsDead() flag)
	if not player:GetData("DeathSet") or player:GetData("DeathSet") < os.time() then
		player:SetData("DeathSet", os.time() + 1) -- Prevents c stack overflows in certain packet loops
		player:KillPlayer()
	end
end

local function On0x269(event, packet, player)
	if player:GetHealth() > 0 and not (player:HasAura(8326) or player:HasAura(20584)) then
		print("Reviving on 0x269")
		RunCommand("revive "..player:GetName())
		player:RegisterEvent(killPlayer, 1100) -- If player is alive 1 second later, it means we gotta try again. KillPlayer() will make this packet fire again.
	end
end

RegisterPacketEvent(0x269, 7, On0x269)

-- Removes former hackfixes that were in place to ensure players didn't get exerted to bugged packet order
WorldDBExecute("DELETE FROM areatrigger WHERE entry = 5001;") -- The Oculus
WorldDBExecute("DELETE FROM areatrigger_teleport WHERE id = 5001;") -- The Oculus
