-- Improves the terrible AzerothCore approach to .learn ###. Won't get stuck if NPC is targeted anymore. made by mostly nick :)

local learnSpellID = {}
local target = nil

local function onCommand(event, player, command)
    if command:match("^%s*learn%s+(%d+)%s*$") then
        local _, _, spellIdStr = command:find("^%s*learn%s+(%d+)%s*$")
        local spellId = tonumber(spellIdStr)

        if spellId then
            if player:GetSelection() and player:GetSelection():IsPlayer() then
                player:GetSelection():LearnSpell(spellId)
				player:RegisterEvent(function(eventId, delay, repeats, player)
					if player:GetSelection() then
						target = player:GetSelection()
					end
					local hasSpell = target and target:IsPlayer() and target:HasSpell(spellId) or player:HasSpell(spellId)

					if not hasSpell then
						player:SendBroadcastMessage("Invalid spell ID. Please provide a valid number.")
					end

					learnSpellID[player:GetGUIDLow()] = nil
				end, 100, 1)
				return false
            else
                player:LearnSpell(spellId)
				player:RegisterEvent(function(eventId, delay, repeats, player)
					if player:GetSelection() then
						target = player:GetSelection()
					end
					local hasSpell = target and target:IsPlayer() and target:HasSpell(spellId) or player:HasSpell(spellId)

					if not hasSpell then
						player:SendBroadcastMessage("Invalid spell ID. Please provide a valid number.")
					end

					learnSpellID[player:GetGUIDLow()] = nil
				end, 100, 1)
				return false
            end

        else
            player:SendBroadcastMessage("Invalid spell ID. Please provide a valid number.")
			return false
        end
    end
end

RegisterPlayerEvent(42, onCommand)
