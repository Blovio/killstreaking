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

local mk_sound_files = {
	"Interface\\AddOns\\Killstreaks\\Sounds\\Brother.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\DoubleKill.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\TripleKill.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Overkill.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Killtacular.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Killtrocity.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Killamanjaro.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Killtastrophe.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Killpocalypse.mp3",
	"Interface\\AddOns\\Killstreaks\\Sounds\\Killionaire.mp3",
}

local mk_killing_sprees = {
	[15] = "Interface\\AddOns\\Killstreaks\\Sounds\\RunningRiot.mp3",
	[20] = "Interface\\AddOns\\Killstreaks\\Sounds\\Rampage.mp3",
	[25] = "Interface\\AddOns\\Killstreaks\\Sounds\\Untouchable.mp3",
	[30] = "Interface\\AddOns\\Killstreaks\\Sounds\\Invincible.mp3",
	[38] = "Interface\\AddOns\\Killstreaks\\Sounds\\Unfrickinbelievable.mp3",
}

local function safePlaySound(soundFile, channel)
	-- Validate that the soundFile is a non-empty string
	if type(soundFile) ~= "string" or soundFile == "" then
		print("Killstreaks[INFO]: Invalid sound file provided:", soundFile)
		return
	end

	-- Use pcall to catch any errors during playback
	local success, err = pcall(PlaySoundFile, soundFile, channel)
	if not success then
		print("Killstreaks[INFO]: Error playing sound file:", soundFile, "-", err)
	end
end

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

		if mk_killing_sprees[dead] then
			safePlaySound(mk_killing_sprees[dead], "Master")
		end

		if isPlayerInRaid then
			if destName == "Neilioeo" then
				SendChatMessage("Good night Neil, my sweet piggly wiggly prince", "SAY")
				safePlaySound("Interface\\AddOns\\Killstreaks\\Sounds\\NeilNo.mp3", "Master")
			elseif destName == "Oakren" then
				SendChatMessage("Oh looks Oakren's dead again....shocker", "SAY")
			else
				if dead <= #multikills then
					SendChatMessage(multikills[dead], "SAY")
					safePlaySound(mk_sound_files[dead], "Master")
				else
					SendChatMessage(multikills[#multikills], "SAY")
				end
			end
		end
	end
end)
