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
	-- TODO: If the player has no money when approaching Charon, use a different useText, like below
	-- if mailboxStatus.TimeRemaining >= 1 then
	-- 	source.UseText = "UseMailbox_DeliveryPending"
	-- 	source.OnUsedFunctionName = "UseMailboxDeliveryPendingPresentation"
	-- else
	-- 	source.UseText = "UseMailbox_DeliveryReady"
	-- 	source.OnUsedFunctionName = "UseMailboxDeliveryReady"
	-- end
	tipJar.UseText = "ModsNikkelMCharonsTipJar_TipJarUseText"
	tipJar.SetupEvents = {}
	tipJar.InteractDistance = 125
	tipJar.OnUsedFunctionName = _PLUGIN.guid .. '.' .. 'TipCharon'

	SetScale({ Id = tipJar.ObjectId, Fraction = 0.2 })
	game.SetupObstacle(tipJar)
	AddToGroup({ Id = tipJar.ObjectId, Name = "ModsNikkelMCharonsTipJar.TipJar" })
end

function mod.TipCharon(usee, args)
	local moneyTipped = game.GameState.Resources.Money
	if moneyTipped == 0 then
		return
	end
	AddInputBlock({ Name = "MelUsedTipJar" })

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
