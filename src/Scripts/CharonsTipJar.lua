local mod = modutil.mod.Mod.Register(_PLUGIN.guid)

-- Charon voicelines thanking for the tip, if he is there himself. Same as purchase responses
local postTippingCharonVoicelines = game.DeepCopyTable(game.GlobalVoiceLines.PurchasedConsumableVoiceLines[2])
-- Charon must be present for this to play
postTippingCharonVoicelines.GameStateRequirements = {
	{
		Path = { "CurrentRun", "CurrentRoom", "Name" },
		IsAny = { "F_PreBoss01", "I_PreBoss01" }
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

-- Add the setup function to the shop room setup events list
table.insert(game.EncounterSets.ShopRoomEvents, {
	FunctionName = _PLUGIN.guid .. '.' .. 'SpawnCharonsTipJar'
})

-- Spawns the tip jar, if the correct room is entered (I_PreBoss01 for Tartarus or Q_PreBoss01 for the Summit) - for testing, F_PreBoss01 for Erebus
function mod.SpawnCharonsTipJar(source, args)
	-- game.GameState.Resources.Money = 0

	-- Defines the starting point for the spawn, against which the offset is applied.
	-- Can get the ObjectId by printing the npc argument in game.UseNPC() if needed
	-- F_PreBoss01: 561301 -- Charon
	-- I_PreBoss01: 619941 -- Charon
	-- P_PreBoss01: 744832 -- Scarecrow obstacle, not an NPC
	-- Q_PreBoss01: 769407 -- Hermes (works also if he is not present)
	local spawnId = nil
	local flipHorizontal = false
	-- Positive Y is down, positive X is right
	local offsetX, offsetY = 0, 0

	-- We only spawn the tip jar in a shop room before the final boss of the run
	if source.Name == "I_PreBoss01" then
		spawnId = 619941
		offsetY = 350
		flipHorizontal = true
	elseif source.Name == "Q_PreBoss01" then
		spawnId = 769407
		offsetX = -450
		offsetY = -1200
		flipHorizontal = true
		-- For testing, not properly placed
		-- elseif source.Name == "F_PreBoss01" then
		-- 	spawnId = 561301
		-- 	offsetX = 0
		-- 	offsetY = 300
	else
		return
	end

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

	-- Overwrite some default values
	tipJar.SetupEvents = {}
	tipJar.InteractDistance = 150

	-- The normal tipping text is shown as the UseText
	tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText"
	-- If the player has no money, the UseTextTalkAndSpecial is shown instead, which is the greyed out Tip? text
	-- This is achieved through the "special" only being available when the player has no money
	-- The special interaction prompt has no actual use, and the normal use function call determines on the fly which of the two functions to call
	tipJar.UseTextTalkAndSpecial = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney"

	tipJar.SpecialInteractGameStateRequirements = {
		{
			Path = { "GameState", "Resources", "Money" },
			Comparison = "<=",
			Value = 0
		}
	}
	-- This will choose which of the presentation functions to call, depending on if the player has money at the moment or not
	tipJar.OnUsedFunctionName = _PLUGIN.guid .. '.' .. 'DetermineAndPlayTippingPresentation'
	-- This is a dummy function that does nothing, as we don't actually show a "Special" button prompt, so don't want to do anything there
	tipJar.SpecialInteractFunctionName = _PLUGIN.guid .. '.' .. 'DummyTippingPresentation'

	SetScale({ Id = tipJar.ObjectId, Fraction = 0.25 })
	game.SetupObstacle(tipJar)
	AddToGroup({ Id = tipJar.ObjectId, Name = "ModsNikkelMCharonsTipJar.TipJar" })
end

-- Determines on-the-fly which of the presentation functions to use
function mod.DetermineAndPlayTippingPresentation(usee, args)
	args = args or {}
	if game.CurrentRun.ModsNikkelMCharonsTipJarCharonTipped then
		args.FloatText = "ModsNikkelMCharonsTipJar_TipJarUseText_AlreadyTipped_FloatText"
		args.MelinoeVoiceLines = tippingAlreadyTippedVoiceLines
		TipCharonLockedPresentation(usee, args)
	elseif game.HasResource("Money", 1) then
		TipCharonPresentation(usee, args)
	else
		args.FloatText = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney_FloatText"
		args.MelinoeVoiceLines = tippingNoMoneyVoiceLines
		TipCharonLockedPresentation(usee, args)
	end
end

-- Does nothing, but cannot be nil
function mod.DummyTippingPresentation(usee, args)
	return
end

function TipCharonPresentation(usee, args)
	AddInputBlock({ Name = "MelUsedTipJar" })
	-- Disable using the tip jar (removes input prompt)
	UseableOff({ Id = usee.ObjectId })

	game.CurrentRun.ModsNikkelMCharonsTipJarCharonTipped = true
	local moneyTipped = game.GameState.Resources.Money

	-- Play animations & voicelines
	TippingPresentation(usee)
	-- Remove money
	game.SpendResources({ Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip")
	-- Count towards rewards card progress
	game.HandleCharonPurchase("ModsNikkelMCharonsTipJarTipCharon", moneyTipped)
	-- Update the amount of money shown to the player
	game.UpdateMoneyUI(true)

	-- Waits for the animations to finish
	game.wait(0.8)
	UseableOn({ Id = usee.ObjectId })
	RemoveInputBlock({ Name = "MelUsedTipJar" })
end

function TipCharonLockedPresentation(usee, args)
	UseableOff({ Id = usee.ObjectId })
	AddInputBlock({ Name = "MelUsedTipJarNoMoney" })
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = usee.ObjectId })
	SetAnimation({ Name = "MelTalkBroodingFull01", DestinationId = game.CurrentRun.Hero.ObjectId })
	PlaySound({ Name = "/Leftovers/World Sounds/CaravanJostle2", Id = usee.ObjectId })

	game.thread(game.PlayVoiceLines, args.MelinoeVoiceLines, true)
	game.thread(game.InCombatText, usee.ObjectId, args.FloatText, 2.5)

	game.wait(2)
	RemoveInputBlock({ Name = "MelUsedTipJarNoMoney" })
	UseableOn({ Id = usee.ObjectId })
end

-- Animations from game.ReceivedGiftPresentation(), without the gifting logic and voicelines
function TippingPresentation(target)
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = target.ObjectId })
	SetAnimation({ Name = "MelTalkGifting01", DestinationId = game.CurrentRun.Hero.ObjectId })

	game.wait(0.35)
	-- Play sound and money VFX as if buying something
	ScaledShoppingSuccessItemPresentation(target)
	-- Replace tip jar with closed version
	SetAnimation({ Name = "SupplyDropObjectClosed", DestinationId = target.ObjectId })

	game.wait(0.15)
	-- Play a voiceline
	game.thread(game.PlayVoiceLines, tippingInteractVoicelines, true)

	SetAnimation({ Name = "MelTalkGifting01ReturnToIdle", DestinationId = game.CurrentRun.Hero.ObjectId })
end

-- Same as game.ShoppingSuccessItemPresentation() but with a scaled up coin pickup animation (to be more visible with the scaled mailbox), and no consumeSound
function ScaledShoppingSuccessItemPresentation(item)
	PlaySound({ Name = "/Leftovers/Menu Sounds/StoreBuyingItem" })
	CreateAnimation({ Name = "MoneyDropCoinPickup", DestinationId = item.ObjectId, Scale = 4, OffsetY = -40 })
end
