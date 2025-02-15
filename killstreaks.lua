local _, killstreaks = ...

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

local killing_sprees = {
	[15] = "Running Riot",
	[20] = "Rampage",
	[25] = "Untouchable",
	[30] = "Invincible",
	[38] = "Unfrickin-believable",
}

local multikill_sounds = {
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

local killing_spree_sounds = {
	[15] = "Interface\\AddOns\\Killstreaks\\Sounds\\RunningRiot.mp3",
	[20] = "Interface\\AddOns\\Killstreaks\\Sounds\\Rampage.mp3",
	[25] = "Interface\\AddOns\\Killstreaks\\Sounds\\Untouchable.mp3",
	[30] = "Interface\\AddOns\\Killstreaks\\Sounds\\Invincible.mp3",
	[38] = "Interface\\AddOns\\Killstreaks\\Sounds\\Unfrickinbelievable.mp3",
}

killstreaks.theme = {
	r = 1,
	g = 0.647, -- 204/255
	b = 0,
	hex = "ffa500",
}

local soundDisabled = false

local function getThemeColor()
	local c = killstreaks.theme
	return c.r, c.g, c.b, c.hex
end

local function toggleSound()
	if soundDisabled then
		soundDisabled = false
		killstreaks:Print("sound has been enabled")
	else
		soundDisabled = true
		killstreaks:Print("sound has been disabled")
	end
end

local function safePlaySound(soundFile, channel)
	if type(soundFile) ~= "string" or soundFile == "" then
		killstreaks:Print("Invalid sound file provided:", soundFile)
		return
	end

	if not soundDisabled then
		local success, err = pcall(PlaySoundFile, soundFile, channel)
		if not success then
			killstreaks:Print("Error playing sound file:", soundFile, "-", err)
		end
	end
end

local function play()
	safePlaySound(killing_spree_sounds[38], "Master")
end

function killstreaks:Print(...)
	local hex = select(4, getThemeColor())
	local prefix = string.format("|cff%s%s|r", hex:upper(), "Killstreaks")
	DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, tostringall(...)))
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

		if isPlayerInRaid then
			if destName == "Neilioeo" then
				SendChatMessage("Good night Neil, my sweet piggly wiggly prince", "SAY")
				safePlaySound("Interface\\AddOns\\Killstreaks\\Sounds\\NeilNo.mp3", "Master")
			elseif destName == "Oakren" then
				SendChatMessage("Oh looks Oakren's dead again....shocker", "SAY")
			else
				if dead <= #multikills then
					SendChatMessage(multikills[dead], "SAY")
					safePlaySound(multikill_sounds[dead], "Master")
				end
				if killing_sprees[dead] then
					SendChatMessage(killing_sprees[dead], "SAY")
					safePlaySound(killing_spree_sounds[dead], "Master")
				end
			end
		end
	end
end)

killstreaks.commands = {
	togglesound = toggleSound,
	play = play,
	help = function()
		killstreaks:Print("List of all slash commands:")
		killstreaks:Print("|cff00cc66/ks help|r - Shows all commands")
		killstreaks:Print("|cff00cc66/ks togglesound|r - turns the sound on or off (default on)")
	end,
}

local function handleSlashCommands(str)
	if #str == 0 then
		killstreaks.commands.help()
	end

	local args = {}
	for _, arg in pairs({ string.split(" ", str) }) do
		if #arg > 0 then
			table.insert(args, arg)
		end
	end

	local path = killstreaks.commands

	for id, arg in ipairs(args) do
		arg = string.lower(arg)

		if path[arg] then
			if type(path[arg]) == "function" then
				path[arg](select(id + 1, args))
				return
			end
		else
			killstreaks.commands.help()
			return
		end
	end
end

-- Register Slash Commands
SLASH_Killstreaks1 = "/killstreaks"
SLASH_Killstreaks2 = "/ks"
SlashCmdList.Killstreaks = handleSlashCommands
