local mod = modutil.mod.Mod.Register(_PLUGIN.guid)
local tippingInteractVoicelines = {
	{ Cue = "/VO/Melinoe_2358",      Text = "This is for you!" }, -- TODO: GameStateRequirement - Charon is present
	{ Cue = "/VO/Melinoe_2358_B",    Text = "This is for you!" }, -- TODO: GameStateRequirement - Charon is present
	{ Cue = "/VO/Melinoe_0187",      Text = "A gift..." },
	{ Cue = "/VO/Melinoe_2355",      Text = "For you!" },        -- TODO: GameStateRequirement - Charon is present
	{ Cue = "/VO/Melinoe_3425",      Text = "In service to the realm." },
	{ Cue = "/VO/Melinoe_0557",      Text = "Here's the Gold." },
	{ Cue = "/VO/Melinoe_1290",      Text = "Lord Charon will want this." }, -- TODO: GameStateRequirement - Charon is not present
	{ Cue = "/VO/MelinoeField_1445", Text = "I do have Gold to spare..." },
	{ Cue = "/VO/MelinoeField_1630", Text = "Who needs Gold anyway..." }
}

local tippingNoMoneyVoiceLines = {
	{ Cue = "/VO/Melinoe_1851", Text = "I'll have to get more." },
	{ Cue = "/VO/Melinoe_1852", Text = "Thought I had more..." },
	{ Cue = "/VO/Melinoe_1223", Text = "Thought I had more Gold..." },
	{ Cue = "/VO/Melinoe_1224", Text = "Don't have the Gold for this." }
}

-- TODO: Charon voicelines thanking for the tip, if he is there himself (not Olympus)

-- Add the function to the shop room events
table.insert(game.EncounterSets.ShopRoomEvents, {
	FunctionName = _PLUGIN.guid .. '.' .. 'SpawnCharonsTipJar'
})

-- Spawns the tip jar, if the correct room is entered (I_PreBoss01 for Tartarus or P_PreBoss01 for Olympus) - for debugging, F_PreBoss01 for Erebus
function mod.SpawnCharonsTipJar(source, args)
	-- We are not in a shop room before the final boss of the run
	if source.Name ~= "I_PreBoss01" and source.Name ~= "P_PreBoss01" and source.Name ~= "F_PreBoss01" then
		return
	end

	-- game.GameState.Resources.Money = 0
	-- Defines the starting point for the spawn, against which the offset is applied. This is Charon
	-- TODO: This is the ID in F_PreBoss01 -- check other rooms
	local spawnId = 561301
	-- Copies the mailbox item
	local tipJar = game.DeepCopyTable(game.HubRoomData.Hub_Main.ObstacleData[583652])

	tipJar.ObjectId = SpawnObstacle({
		Name = "SupplyDropObject",
		Group = "Standing",
		DestinationId = spawnId,
		AttachedTable = tipJar,
		OffsetX = 0,
		OffsetY = 300,
	})
	tipJar.ActivateIds = { tipJar.ObjectId }

	-- Overwrite some default values
	-- TODO: Re-evaluate this whenever the amount of money changes
	if game.HasResource("Money", 1) then
		tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText"
		tipJar.OnUsedFunctionName = _PLUGIN.guid .. '.' .. 'TipCharonPresentation'
	else
		-- TODO: Also remove sparkle effect - would need to copy and remove childanimation from SupplyDropObjectEmpty in Items_General_VFX.sjson
		tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney"
		tipJar.OnUsedFunctionName = _PLUGIN.guid .. '.' .. 'TipCharonNoMoneyPresentation'
	end

	tipJar.SetupEvents = {}
	tipJar.InteractDistance = 150

	SetScale({ Id = tipJar.ObjectId, Fraction = 0.2 })
	game.SetupObstacle(tipJar)
	AddToGroup({ Id = tipJar.ObjectId, Name = "ModsNikkelMCharonsTipJar.TipJar" })
end

function mod.TipCharonPresentation(usee, args)
	AddInputBlock({ Name = "MelUsedTipJar" })
	local moneyTipped = game.GameState.Resources.Money

	-- Play animationsn
	TippingPresentation(usee)
	-- Remove money
	game.SpendResources({ Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip")
	-- Count towards rewards card progress
	game.HandleCharonPurchase("ModsNikkelMCharonsTipJarTipCharon", moneyTipped)
	-- Update the amount of money shown to the player
	game.UpdateMoneyUI(true)
	-- Disable using the tip jar (removes input prompt)
	UseableOff({ Id = usee.ObjectId })

	game.wait(0.5)
	RemoveInputBlock({ Name = "MelUsedTipJar" })
end

function mod.TipCharonNoMoneyPresentation(usee, args)
	UseableOff({ Id = usee.ObjectId })
	AddInputBlock({ Name = "MelUsedTipJarNoMoney" })
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = usee.ObjectId })
	SetAnimation({ Name = "MelTalkBroodingFull01", DestinationId = game.CurrentRun.Hero.ObjectId })
	PlaySound({ Name = "/Leftovers/World Sounds/CaravanJostle2", Id = usee.ObjectId })

	game.thread(game.PlayVoiceLines, tippingNoMoneyVoiceLines, true)
	game.thread(game.InCombatText, usee.ObjectId, "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney_FloatText", 2.5)
	game.wait(2)
	RemoveInputBlock({ Name = "MelUsedTipJarNoMoney" })
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

-- Same as game.ShoppingSuccessItemPresentation() but with a scaled up coin pickup animation (to be more visible with the scaled down mailbox), and no consumeSound
function ScaledShoppingSuccessItemPresentation(item)
	PlaySound({ Name = "/Leftovers/Menu Sounds/StoreBuyingItem" })
	CreateAnimation({ Name = "MoneyDropCoinPickup", DestinationId = item.ObjectId, Scale = 4, OffsetY = -40 })
end
