local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local multikills = {
	"Noob DOWN!",
	"Double Kill",
	"Triple Kill",
	"Overkill",
	"Killtacular",
	"Killtrocity",
	"Killamanjaro",
	"Killtastrophe",
	"Killpocalypse",
	"Killionaire",
}

frame:SetScript("OnEvent", function()
	local _, subEvent, _, _, _, _, _, _, destName, _, _, _ = CombatLogGetCurrentEventInfo()

	if subEvent == "UNIT_DIED" then
		-- Ignore deaths from players who used Feign Death
		if UnitIsFeignDeath(destName) then
			return
		end

		local dead = 0
		local isPlayerInRaid = false
		for i = 1, GetNumGroupMembers() do
			local raidMemberName, _, _, _, _, _, _, _, isDead = GetRaidRosterInfo(i)
			-- Everytime player dies count all dead
			if isDead then
				dead = dead + 1
			end
			if raidMemberName == destName then
				isPlayerInRaid = true
			end
		end

		if isPlayerInRaid then
			if destName == "Neilioeo" then
				SendChatMessage("Good night Neil, my sweet piggly wiggly prince", "SAY")
			elseif destName == "Oakren" then
				SendChatMessage("Oh looks Oakren's dead again....shocker", "SAY")
			else
				if dead <= #multikills then
					SendChatMessage(multikills[dead], "SAY")
				else
					SendChatMessage(multikills[#multikills], "SAY")
				end
			end
		end
	end
end)
