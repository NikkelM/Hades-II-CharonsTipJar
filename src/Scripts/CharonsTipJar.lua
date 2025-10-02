local mod = modutil.mod.Mod.Register(_PLUGIN.guid)

-- Charon voicelines thanking for the tip, if he is there himself. Same as purchase responses
local postTippingCharonVoicelines = game.DeepCopyTable(game.GlobalVoiceLines.PurchasedConsumableVoiceLines[2])
-- Charon must be present for this to play
postTippingCharonVoicelines.GameStateRequirements = {
	{
		Path = { "CurrentRun", "CurrentRoom", "Name" },
		IsAny = { "F_PreBoss01", "G_PreBoss01", "H_PreBoss01", "I_PreBoss01", "I_PreBoss02", "N_PreBoss01", "O_PreBoss01" }
	}
}
postTippingCharonVoicelines.ChanceToPlay = 1

local tippingInteractVoicelines = {
	{
		-- DO NOT set BreakIfPlayed to true, as this will cause the next set of voicelines (Charon thanking) to be skipped
		-- BreakIfPlayed = false,
		RandomRemaining = true,
		PreLineWait = 0.25,
		Cooldowns =
		{
			{ Name = "MelinoeAnyQuipSpeech" },
		},
		-- Charon must be present (Erebus, Tartarus)
		{
			Cue = "/VO/Melinoe_2358",
			Text = "This is for you!",
			GameStateRequirements =
			{
				{
					Path = { "CurrentRun", "CurrentRoom", "Name" },
					IsAny = { "F_PreBoss01", "I_PreBoss01" }
				}
			}
		},
		{
			Cue = "/VO/Melinoe_2358_B",
			Text = "This is for you!",
			GameStateRequirements =
			{
				{
					Path = { "CurrentRun", "CurrentRoom", "Name" },
					IsAny = { "F_PreBoss01", "I_PreBoss01" }
				}
			}
		},
		{
			Cue = "/VO/Melinoe_2355",
			Text = "For you!",
			GameStateRequirements =
			{
				{
					Path = { "CurrentRun", "CurrentRoom", "Name" },
					IsAny = { "F_PreBoss01", "I_PreBoss01" }
				}
			}
		},
		{
			Cue = "/VO/Melinoe_0557",
			Text = "Here's the Gold.",
			GameStateRequirements =
			{
				{
					Path = { "CurrentRun", "CurrentRoom", "Name" },
					IsAny = { "F_PreBoss01", "I_PreBoss01" }
				}
			}
		},
		-- Charon must *not* be present (Summit)
		{
			Cue = "/VO/Melinoe_1290",
			Text = "Lord Charon will want this.",
			GameStateRequirements =
			{
				{
					Path = { "CurrentRun", "CurrentRoom", "Name" },
					IsAny = { "Q_PreBoss01" }
				}
			}
		},
		-- Anything works
		{ Cue = "/VO/Melinoe_0187",      Text = "A gift..." },
		{ Cue = "/VO/Melinoe_3425",      Text = "In service to the realm." },
		{ Cue = "/VO/MelinoeField_1445", Text = "I do have Gold to spare..." },
		{ Cue = "/VO/MelinoeField_1630", Text = "Who needs Gold anyway..." }
	},
	postTippingCharonVoicelines
}

local tippingNoMoneyVoiceLines = {
	RandomRemaining = true,
	PreLineWait = 0.25,
	Cooldowns =
	{
		{ Name = "MelinoeAnyQuipSpeech" },
	},
	{ Cue = "/VO/Melinoe_1851", Text = "I'll have to get more." },
	{ Cue = "/VO/Melinoe_1852", Text = "Thought I had more..." },
	{ Cue = "/VO/Melinoe_1223", Text = "Thought I had more Gold..." },
	{ Cue = "/VO/Melinoe_1224", Text = "Don't have the Gold for this." }
}

local tippingAlreadyTippedVoiceLines = {
	RandomRemaining = true,
	PreLineWait = 0.25,
	Cooldowns =
	{
		{ Name = "MelinoeAnyQuipSpeech" },
	},
	{ Cue = "/VO/Melinoe_3084", Text = "No use." },
	{ Cue = "/VO/Melinoe_2386", Text = "Can't do it." }
}

-- If Charon is present in this room
local modsNikkelMCharonsTipJarTipJarIntro01_A = {
	Name = "ModsNikkelMCharonsTipJarTipJarIntro01_A",
	PlayOnce = true,
	PreEventFunctionName = _PLUGIN.guid .. "." .. "SetConversationIds",
	{
		UsePlayerSource = true,
		PreLineAnim = "MelTalkPensive01",
		PreLineAnimTarget = "Hero",
		Text =
		"What is this over here, Lord Charon? The box with all the coins in it? I don't suppose this is some sort of new ware to help me with my task, is it?"
	},
	{
		Cue = "/VO/Charon_0036",
		Source = "NPC_Charon_01",
		Portrait = "Portrait_Charon_Default_01",
		PreLineAnim = "Charon_Greeting",
		Text = "{#Emph}Haaaa{#Prev}, hrrrnnnnggghhh..."
	},
	{
		UsePlayerSource = true,
		PreLineAnim = "MelTalkBrooding01",
		PreLineAnimTarget = "Hero",
		PostLineAnim = "MelinoeIdleWeaponless",
		PostLineAnimTarget = "Hero",
		Portrait = "Portrait_Mel_Casual_01",
		Text =
		"You're right, I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon. I might as well leave the coins with you now to have them disposed of properly."
	},
	{
		Cue = "/VO/Charon_0011",
		Source = "NPC_Charon_01",
		Portrait = "Portrait_Charon_Default_01",
		PreLineAnim = "Charon_Thanking",
		Text = "{#Emph}Hrrnnaaaauugghh..."
	},
	{
		UsePlayerSource = true,
		PreLineAnim = "MelTalkExplaining01",
		PreLineAnimTarget = "Hero",
		PostLineAnim = "MelinoeIdleWeaponless",
		PostLineAnimTarget = "Hero",
		Portrait = "Portrait_Mel_Pleased_01",
		Text =
		"Why thank you! I hope you know it is entirely unnecessary for you to include these tips in your loyalty program, but I do appreciate it nonetheless, my lord."
	},
	EndVoiceLines = {
		PreLineWait = 0.2,
		ObjectType = "NPC_Charon_01",
		{ Cue = "/VO/Charon_0148", Text = "{#Emph}Mmmm..." },
	},
}

-- If Charon is not present in this room
local modsNikkelMCharonsTipJarTipJarIntro01_B = {
	Name = "ModsNikkelMCharonsTipJarTipJarIntro01_B",
	PlayOnce = true,
	PreEventFunctionName = _PLUGIN.guid .. "." .. "SetConversationIds",
	{
		UsePlayerSource = true,
		PreLineAnim = "MelTalkPensive01",
		PreLineAnimTarget = "Hero",
		Portrait = "Portrait_Mel_Casual_01",
		Text =
		"Oh, there is a note on this box... {#Emph}Hey M. Leave any leftover Gold you have in here. Hermes will get it to me. Charon"
	},
	{
		UsePlayerSource = true,
		Portrait = "Portrait_Mel_Intense_01",
		Text =
		"He's right. I won't have any use for the remaining Gold in my possession going forward. One way or another, I will return to shadow soon."
	},
	{
		UsePlayerSource = true,
		PostLineAnim = "MelinoeIdleWeaponless",
		PostLineAnimTarget = "Hero",
		Portrait = "Portrait_Mel_Default_01",
		Text =
		"There is more on the back... {#Emph}I will count any tips you leave towards your rewards. Honor system."
	},
}

-- Add the setup function to the shop room setup events list
table.insert(game.EncounterSets.ShopRoomEvents, {
	FunctionName = _PLUGIN.guid .. "." .. "SpawnCharonsTipJar"
})
-- I_PreBoss02 appends more things to the shop room setup events list, which somehow removes our entry, so add it to the appended table as well
table.insert(game.RoomData.I_PreBoss02.StartUnthreadedEvents, {
	FunctionName = _PLUGIN.guid .. "." .. "SpawnCharonsTipJar"
})

-- Spawns the tip jar, if the correct room is entered (I_PreBoss01 for Tartarus or Q_PreBoss01 for the Summit) - for testing, F_PreBoss01 for Erebus
function mod.SpawnCharonsTipJar(source, args)
	-- Defines the starting point for the spawn, against which the offset is applied.
	-- Can get the ObjectId by printing the npc argument in game.UseNPC() if needed
	-- F_PreBoss01: 561301 -- Charon
	-- 							776332 -- ZagContractReward
	-- G_PreBoss01: 561345 -- Charon
	-- 							776334 -- ZagContractReward
	-- H_PreBoss01: 565394 -- Charon
	-- 							776337 -- ZagContractReward
	-- I_PreBoss01: 619941 -- Charon
	-- 							776340 -- ZagContractReward
	-- I_PreBoss02: 619941 -- Charon
	-- 							800817 -- ZagContractReward
	-- N_PreBoss01: 561342 -- Charon
	-- 							776338 -- ZagContractReward
	-- O_PreBoss01: 690991 -- Charon
	-- 							776340 -- ZagContractReward
	-- P_PreBoss01: 744832 -- Scarecrow obstacle, not an NPC
	-- 							778667 -- ZagContractReward
	-- Q_PreBoss01: 769407 -- Hermes (works also if he is not present)
	-- 							793525 -- ZagContractReward
	local spawnId = nil
	local charonId = nil
	local flipHorizontal = false
	-- Positive X is right, positive Y is down
	local offsetX, offsetY = 0, 0
	-- Is this a normal bounty (not a Chaos above/below trial)?
	local isStandardPackageBountyActive = IsGameStateEligible(source,
		game.NamedRequirementsData.StandardPackageBountyActive, args)

	-- Always spawn the tip jar in a shop room before the final boss of the run
	if source.Name == "I_PreBoss01" then
		-- Based on Charon, to the bottom left of him
		spawnId = 619941
		charonId = 619941
		offsetX = -60
		offsetY = 390
		flipHorizontal = true
	elseif source.Name == "I_PreBoss02" then
		-- Based on Charon, to the bottom left of him
		spawnId = 619941
		charonId = 619941
		offsetX = -220
		offsetY = 510
		flipHorizontal = true
	elseif source.Name == "Q_PreBoss01" then -- Done
		-- Based on Hermes to the bottom left of the exit door
		spawnId = 769407
		charonId = nil
		offsetX = -450
		offsetY = -1200
		flipHorizontal = true
		-- If we are in a "normal" Chaos trial, also spawn the tip jar in all other pre-boss rooms
		-- Spawn it on the ZagContractReward, as Zag contracts cannot appear in normal Chaos trials
	elseif isStandardPackageBountyActive then
		if source.Name == "F_PreBoss01" then -- Done
			-- Based on Charon offset to the right next to the exit door
			spawnId = 561301
			charonId = 561301
			offsetX = 630
			offsetY = 150
		elseif source.Name == "G_PreBoss01" then -- Done
			-- On the ZagContractReward, between Charon and the shop items
			spawnId = 776334
		elseif source.Name == "H_PreBoss01" then -- Done
			-- Based on ZagContractReward slightly top-right of Charon between him and the exit door
			-- spawnId = 776337
			-- charonId = 565394
			-- offsetX = -275
			-- offsetY = -480
			-- Based on Charon to the bottom right of the exit door
			spawnId = 565394
			charonId = 565394
			offsetX = 850
			offsetY = 120
		elseif source.Name == "N_PreBoss01" then -- Done
			-- Based on ZagContractReward to the bottom left of the exit door, below the vases
			spawnId = 776338
			charonId = 561342
			offsetX = 225
			offsetY = -160
			flipHorizontal = true
		elseif source.Name == "O_PreBoss01" then -- Done
			-- Based on Charon scarecrow above it to the left of the exit door
			spawnId = 690991
			charonId = 690991
			offsetX = 150
			offsetY = -350
		elseif source.Name == "P_PreBoss01" then -- Done
			-- Based on ZagContractReward to the right of the rewards to the left of the stairs
			spawnId = 778667
			charonId = nil
			offsetX = 1380
			offsetY = -490
		else
			return
		end
	else
		return
	end

	-- We need to load the package containing the obstacle graphics
	LoadPackages({ Name = "BiomeHub" })

	-- Copies the mailbox item
	local tipJar = game.DeepCopyTable(game.HubRoomData.Hub_Main.ObstacleData[583652])

	tipJar.ObjectId = SpawnObstacle({
		Name = "SupplyDropObject",
		Group = "Standing",
		DestinationId = spawnId,
		AttachedTable = tipJar,
		OffsetX = offsetX,
		OffsetY = offsetY,
	})
	tipJar.ActivateIds = { tipJar.ObjectId }

	if flipHorizontal then
		FlipHorizontal({ Id = tipJar.ObjectId })
	end

	-- If the tip jar has not been introduced yet, give it a status animation
	tipJar.SetupEvents = {
		{
			FunctionName = "PlayStatusAnimation",
			Args = { Animation = "StatusIconWantsToTalkImportant" },
			GameStateRequirements = {
				{
					Path = { "GameState", "TextLinesRecord" },
					HasNone = { "ModsNikkelMCharonsTipJarTipJarIntro01_A", "ModsNikkelMCharonsTipJarTipJarIntro01_B" }
				},
			},
		},
	}
	tipJar.CharonId = charonId
	tipJar.DistanceTriggers = {}
	tipJar.InteractDistance = 150

	tipJar.CanReceiveGift = true
	tipJar.ReceiveGiftFunctionName = _PLUGIN.guid .. "." .. "DummyTippingPresentation"
	-- The normal tipping text is shown as the UseText
	tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText"
	-- If the player can talk to the tip jar (always true), and additionally has money AND has already tipped, canAssist is true, and the below text is shown instead of the normal UseText
	tipJar.UseTextTalkAndSpecial = "ModsNikkelMCharonsTipJar_TipJarUseText_AlreadyTipped"
	tipJar.SpecialInteractGameStateRequirements = {
		{
			Path = { "GameState", "Resources", "Money" },
			Comparison = ">",
			Value = 0
		},
		{
			PathTrue = { "CurrentRun", "CurrentRoom", "ModsNikkelMCharonsTipJarCharonTipped" },
		},
	}
	-- If the player can talk to the jar (always true), and additionally has no money (which automatically makes sure canAssist is not true at the same time), canGift is true, and the below text is shown instead of the normal UseText
	tipJar.UseTextTalkAndGift = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney"
	tipJar.GiftGameStateRequirements = {
		{
			Path = { "GameState", "Resources", "Money" },
			Comparison = "<=",
			Value = 0
		}
	}

	-- This will choose which of the presentation functions to call, depending on if the player has money at the moment or not
	-- Unrelated to which text is shown
	tipJar.OnUsedFunctionName = _PLUGIN.guid .. "." .. "DetermineAndPlayTippingPresentation"
	-- This is a dummy function that does nothing, as we don't actually show a "Special" button prompt, so don't want to do anything there
	tipJar.SpecialInteractFunctionName = _PLUGIN.guid .. "." .. "DummyTippingPresentation"

	SetScale({ Id = tipJar.ObjectId, Fraction = 0.25 })
	game.SetupObstacle(tipJar)
	AddToGroup({ Id = tipJar.ObjectId, Name = "ModsNikkelMCharonsTipJar.TipJar" })
end

-- Determines on-the-fly which of the presentation functions to use
function mod.DetermineAndPlayTippingPresentation(usee, args)
	args = args or {}

	-- If this is the first time interacting with the tip jar, play the appropiate intro conversation first
	if not game.GameState.TextLinesRecord.ModsNikkelMCharonsTipJarTipJarIntro01_A and not game.GameState.TextLinesRecord.ModsNikkelMCharonsTipJarTipJarIntro01_B then
		if usee.CharonId ~= nil then
			game.PlayTextLines(usee, modsNikkelMCharonsTipJarTipJarIntro01_A)
		else
			game.PlayTextLines(usee, modsNikkelMCharonsTipJarTipJarIntro01_B)
		end
		-- Don't immediately tip - prevents accidentally tipping before shopping if the exclamation mark is distracting
		return
	end

	if game.CurrentRun.CurrentRoom.ModsNikkelMCharonsTipJarCharonTipped then
		args.FloatText = "ModsNikkelMCharonsTipJar_AlreadyTipped_FloatText"
		args.MelinoeVoiceLines = tippingAlreadyTippedVoiceLines
		args.CombatTextOffsetY = -70
		mod.TipCharonLockedPresentation(usee, args)
	elseif game.HasResource("Money", 1) then
		if game.HasResource("Money", 200) then
			args.FloatText = "ModsNikkelMCharonsTipJar_TipInProgress_Generous_FloatText"
		else
			args.FloatText = "ModsNikkelMCharonsTipJar_TipInProgress_FloatText"
		end
		args.CombatTextOffsetY = -70
		mod.TipCharonPresentation(usee, args)
	else
		args.FloatText = "ModsNikkelMCharonsTipJar_NoMoney_FloatText"
		args.MelinoeVoiceLines = tippingNoMoneyVoiceLines
		args.CombatTextOffsetY = -120
		mod.TipCharonLockedPresentation(usee, args)
	end
end

-- Does nothing, but cannot be nil
function mod.DummyTippingPresentation(usee, args)
	return
end

function mod.TipCharonPresentation(usee, args)
	AddInputBlock({ Name = "MelUsedTipJar" })
	-- Disable using the tip jar (removes input prompt)
	UseableOff({ Id = usee.ObjectId })

	game.CurrentRun.CurrentRoom.ModsNikkelMCharonsTipJarCharonTipped = true
	local moneyTipped = game.GameState.Resources.Money

	-- Play animations & voicelines
	mod.TippingPresentation(usee)
	-- Show "tip accepted" text
	game.thread(game.InCombatText, usee.ObjectId, args.FloatText, 2.2, { OffsetY = args.CombatTextOffsetY })
	-- Remove money
	game.SpendResources({ Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip")
	-- Count towards rewards card progress
	game.HandleCharonPurchase("ModsNikkelMCharonsTipJarTipCharon", moneyTipped)
	-- Update the amount of money shown to the player
	game.UpdateMoneyUI(true)

	-- Waits for the animations to finish
	game.wait(0.8)
	RemoveInputBlock({ Name = "MelUsedTipJar" })
	-- Additional delay before the tip jar can be used again to prevent the float text overlapping
	game.wait(0.8)
	UseableOn({ Id = usee.ObjectId })
end

function mod.TipCharonLockedPresentation(usee, args)
	UseableOff({ Id = usee.ObjectId })
	AddInputBlock({ Name = "MelUsedTipJarNoMoney" })
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = usee.ObjectId })
	SetAnimation({ Name = "MelTalkBroodingFull01", DestinationId = game.CurrentRun.Hero.ObjectId })
	PlaySound({ Name = "/Leftovers/World Sounds/CaravanJostle2", Id = usee.ObjectId })

	game.thread(game.PlayVoiceLines, args.MelinoeVoiceLines, true)
	game.thread(game.InCombatText, usee.ObjectId, args.FloatText, 2.5, { OffsetY = args.CombatTextOffsetY })

	game.wait(2)
	RemoveInputBlock({ Name = "MelUsedTipJarNoMoney" })
	UseableOn({ Id = usee.ObjectId })
end

-- Animations from game.ReceivedGiftPresentation(), without the gifting logic and voicelines
function mod.TippingPresentation(target)
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = target.ObjectId })
	SetAnimation({ Name = "MelTalkGifting01", DestinationId = game.CurrentRun.Hero.ObjectId })

	game.wait(0.35)
	-- Play sound and money VFX as if buying something
	mod.ScaledShoppingSuccessItemPresentation(target)
	-- Replace tip jar with closed version
	SetAnimation({ Name = "SupplyDropObjectClosed", DestinationId = target.ObjectId })

	game.wait(0.15)
	-- Play a voiceline
	game.thread(game.PlayVoiceLines, tippingInteractVoicelines, true)

	SetAnimation({ Name = "MelTalkGifting01ReturnToIdle", DestinationId = game.CurrentRun.Hero.ObjectId })
end

-- Same as game.ShoppingSuccessItemPresentation() but with a scaled up coin pickup animation (to be more visible with the scaled mailbox), and no consumeSound
function mod.ScaledShoppingSuccessItemPresentation(item)
	PlaySound({ Name = "/Leftovers/Menu Sounds/StoreBuyingItem" })
	CreateAnimation({ Name = "MoneyDropCoinPickup", DestinationId = item.ObjectId, Scale = 4, OffsetY = -40 })
end

-- Source is the tip jar
function mod.SetConversationIds(source, args, textLines)
	if not source.CharonId then
		-- The first Mel cue should have her look at the tip jar
		textLines[1].AngleHeroTowardTargetId = source.ObjectId
	else
		-- The first Mel cue should have her look at Charon
		textLines[1].AngleHeroTowardTargetId = source.CharonId
		-- The Charon cues should have him as source
		for _, line in ipairs(textLines) do
			if line.Portrait and line.Portrait:find("Charon") then
				if line.PreLineAnim then
					line.PreLineAnimTarget = source.CharonId
				end
			end
		end
	end
end
