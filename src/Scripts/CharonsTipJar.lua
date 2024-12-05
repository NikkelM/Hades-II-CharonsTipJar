local mod = modutil.mod.Mod.Register(_PLUGIN.guid)

-- For debugging - Erebus
table.insert(game.RoomSetData.F.F_PreBoss01.StartUnthreadedEvents,
	{
		FunctionName = _PLUGIN.guid .. '.' .. 'SpawnCharonsTipJar',
		Args = { Location = "F_PreBoss01" }
	})

-- Tartarus
table.insert(game.RoomSetData.I.I_PreBoss01.StartUnthreadedEvents,
	{
		FunctionName = _PLUGIN.guid .. '.' .. 'SpawnCharonsTipJar',
		Args = { Location = "I_PreBoss01" }
	})

-- Olympus
table.insert(game.RoomSetData.P.P_PreBoss01.StartUnthreadedEvents,
	{
		FunctionName = _PLUGIN.guid .. '.' .. 'SpawnCharonsTipJar',
		Args = { Location = "P_PreBoss01" }
	})

function mod.SpawnCharonsTipJar(source, args)
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
	-- TODO: Re-evaluate this whenever the amount of money changes - Check HasResource("Money", 1)
	-- local playerMoney = game.GameState.Resources.Money
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

	-- Play gift giving animation
	GiftGivingAnimation(usee)
	-- Remove money
	game.SpendResources({ Money = moneyTipped }, "ModsNikkelMCharonsTipJarCharonTip")
	-- Count towards rewards card progress
	game.HandleCharonPurchase("ModsNikkelMCharonsTipJarTipCharon", moneyTipped)
	-- Update the amount of money shown to the player
	game.UpdateMoneyUI(true)
	-- Play sound and animation as if buying something
	ScaledShoppingSuccessItemPresentation(usee)
	-- Replace tip jar with closed version
	SetAnimation({ Name = "SupplyDropObjectClosed", DestinationId = usee.ObjectId })
	-- Disable using the tip jar (removes input prompt)
	UseableOff({ Id = usee.ObjectId })

	game.wait(0.3)
	RemoveInputBlock({ Name = "MelUsedTipJar" })
end

function mod.TipCharonNoMoneyPresentation(usee, args)
	UseableOff({ Id = usee.ObjectId })
	game.HideUseButton(usee.ObjectId, usee) -- TODO: Needed?
	AddInputBlock({ Name = "MelUsedTipJarNoMoney" })
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = usee.ObjectId })
	SetAnimation({ Name = "MelTalkBroodingFull01", DestinationId = game.CurrentRun.Hero.ObjectId })
	PlaySound({ Name = "/Leftovers/World Sounds/CaravanJostle2", Id = usee.ObjectId })
	-- TODO: Voicelines for no money?
	-- game.thread( game.PlayVoiceLines, GlobalVoiceLines.WaitingForMailboxItemVoiceLines, true )
	game.thread(game.InCombatText, usee.ObjectId, "ModsNikkelMCharonsTipJar_TipJarUseText_NoMoney_FloatText", 2.5)
	game.wait(2)
	RemoveInputBlock({ Name = "MelUsedTipJarNoMoney" })
end

-- Animations from game.ReceivedGiftPresentation(), without the gifting logic and voicelines
function GiftGivingAnimation(target)
	AngleTowardTarget({ Id = game.CurrentRun.Hero.ObjectId, DestinationId = target.ObjectId })
	SetAnimation({ Name = "MelTalkGifting01", DestinationId = game.CurrentRun.Hero.ObjectId })

	game.wait(0.50)
	SetAnimation({ Name = "MelTalkGifting01ReturnToIdle", DestinationId = game.CurrentRun.Hero.ObjectId })
	game.wait(0.65)
end

-- Same as game.ShoppingSuccessItemPresentation() but with a scaled up coin pickup animation (to be more visible with the scaled down mailbox), and no consumeSound
function ScaledShoppingSuccessItemPresentation(item)
	PlaySound({ Name = "/Leftovers/Menu Sounds/StoreBuyingItem" })
	CreateAnimation({ Name = "MoneyDropCoinPickup", DestinationId = item.ObjectId, Scale = 4 })
end
